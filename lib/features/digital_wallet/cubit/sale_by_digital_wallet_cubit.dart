import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:amwal_pay_sdk/core/apiview/state_mapper.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/digital_wallet/model/digital_wallet_response.dart';
import 'package:pay/pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../card/data/models/request/purchase_request.dart';
import '../../card/data/models/response/purchase_response.dart';
import '../../card/domain/use_case/purchase_apple_samsung_pay.dart';
import '../../../amwal_pay_sdk.dart';
import '../../../features/receipt/receipt_handler.dart';
import '../../../core/ui/transactiondialog/transaction_details_settings.dart';
import '../../../core/ui/transactiondialog/transaction_status_dialog.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_setting_container.dart';
import 'package:amwal_pay_sdk/features/card/domain/use_case/purchase_apple_samsung_pay.dart';
import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';

import '../../card/transaction_manager/transaction_util_dialog.dart';
import '../constants/digital_wallet_constants.dart';

class SaleByDigitalWalletCubit extends ICubit<DigitalWalletResponse>
    with UiState<DigitalWalletResponse> {
  final Pay _pay;
  final BuildContext context;
  final Function(String) onResponse;
  final Function() dismissDialog;
  final Function(String) log;
  final PurchaseAppleSamsungPayUseCase _purchaseAppleSamsungPayUseCase;
  StreamSubscription? _paymentResultSubscription;
  Map<String, String> _currentPaymentDetails = {};

  SaleByDigitalWalletCubit({
    required this.context,
    required this.onResponse,
    required this.dismissDialog,
    required this.log,
    required PurchaseAppleSamsungPayUseCase purchaseAppleSamsungPayUseCase,
  })  : _pay = Pay({
          PayProvider.apple_pay: PaymentConfiguration.fromJsonString(
              DigitalWalletConstants.applePayConfigString),
          PayProvider.google_pay: PaymentConfiguration.fromJsonString(
              DigitalWalletConstants.googlePayConfigString),
        }),
        _purchaseAppleSamsungPayUseCase = purchaseAppleSamsungPayUseCase {
    _setupPaymentResultListener();
  }

  void _setupPaymentResultListener() {
    if (Platform.isAndroid) {
      const eventChannel =
          EventChannel('plugins.flutter.io/pay/payment_result');
      _paymentResultSubscription = eventChannel
          .receiveBroadcastStream()
          .map((result) => jsonDecode(result as String) as Map<String, dynamic>)
          .listen((result) {
        _handlePaymentResult(result);
      }, onError: (error) {
        _handlePaymentError('Payment error: $error');
      });
    }
  }

  void _handlePaymentResult(Map<String, dynamic> result) {
    log('Payment result received: ${jsonEncode(result)}');

    // Extract payment data from the result
    final paymentData = result['paymentMethodData'] as Map<String, dynamic>?;
    if (paymentData == null) {
      _handlePaymentError('Invalid payment result: missing payment data');
      return;
    }

    final token = paymentData['token'] as String? ?? '';
    if (token.isEmpty) {
      _handlePaymentError('Invalid payment result: missing token');
      return;
    }

    // Use stored payment details or extract from result
    final amount =
        double.tryParse(_currentPaymentDetails['amount'] ?? '0') ?? 0;
    final terminalId = _currentPaymentDetails['terminalId'] ?? '0';
    final merchantId =
        int.tryParse(_currentPaymentDetails['merchantId'] ?? '0') ?? 0;
    final transactionId = _currentPaymentDetails['transactionId'] ?? '';

    // Process the payment with the token
    _processPaymentWithToken(
      result: result,
      amount: amount,
      terminalId: terminalId,
      merchantId: merchantId,
      transactionId: transactionId,
    );
  }

  @override
  Future<void> close() {
    _paymentResultSubscription?.cancel();
    return super.close();
  }

  /// Checks if digital wallet payments are available on the device
  Future<bool> canMakePayments() async {
    try {
      if (Platform.isIOS) {
        return await _pay.userCanPay(PayProvider.apple_pay);
      } else if (Platform.isAndroid) {
        return await _pay.userCanPay(PayProvider.google_pay);
      }
      return false;
    } catch (e) {
      log('Error checking if payments are available: $e');
      return false;
    }
  }

  /// Checks if the device has active cards for digital wallet payments
  Future<bool> canMakePaymentsWithActiveCard() async {
    return await canMakePayments();
  }

  /// Processes a digital wallet payment
  Future<void> processDigitalWalletPayment({
    required double amount,
    required String terminalId,
    required String currency,
    required int currencyId,
    required int merchantId,
    required String transactionId,
  }) async {
    try {
      emit(const ICubitState<DigitalWalletResponse>.loading());

      if (!await _validateDigitalWalletAvailability()) {
        return;
      }

      // Store payment details for later use
      _storePaymentDetails(amount, terminalId, merchantId, transactionId);

      final result = await _requestPaymentToken(
        amount: amount,
        terminalId: terminalId,
        merchantId: merchantId,
        transactionId: transactionId,
      );

      if (result == null || result.toString().isEmpty) {
        _handlePaymentError('Failed to get payment token');
        return;
      }

      await _processPaymentWithToken(
          amount: amount,
          terminalId: terminalId,
          merchantId: merchantId,
          transactionId: transactionId,
          result: result);
    } catch (e) {
      log('Error processing payment: $e');
      _handlePaymentError('An unexpected error occurred: $e');
    }
  }

  /// Validates if digital wallet payments are available
  Future<bool> _validateDigitalWalletAvailability() async {
    bool isAvailable = await canMakePayments();
    if (!isAvailable) {
      _handlePaymentError(
          'Digital wallet payments are not available on this device');
      return false;
    }
    return true;
  }

  /// Requests a payment token from the digital wallet
  Future<Map<String, dynamic>?> _requestPaymentToken({
    required double amount,
    required String terminalId,
    required int merchantId,
    required String transactionId,
  }) async {
    final paymentItems = _getPaymentItems(amount);

    try {
      if (Platform.isIOS) {
        log('Requesting Apple Pay payment');
        final result = await _pay.showPaymentSelector(
          PayProvider.apple_pay,
          paymentItems,
        );
        log('Apple Pay result: $result');
        return result;
      } else if (Platform.isAndroid) {
        log('Requesting Google Pay payment');
        final result = await _pay.showPaymentSelector(
          PayProvider.google_pay,
          paymentItems,
        );
        log('Google Pay result: $result');
        // For Android, the actual result will come through the event channel
        return result;
      }
    } catch (e) {
      log('Payment error: $e');
      _handlePaymentError('Payment failed: $e');
    }
    return null;
  }

  // Store payment details for Android to use with the event channel
  void _storePaymentDetails(
    double amount,
    String terminalId,
    int merchantId,
    String transactionId,
  ) {
    _currentPaymentDetails = {
      'amount': amount.toString(),
      'terminalId': terminalId,
      'merchantId': merchantId.toString(),
      'transactionId': transactionId,
    };
    log('Stored payment details: ${jsonEncode(_currentPaymentDetails)}');
  }

  List<PaymentItem> _getPaymentItems(double amount) {
    return [
      PaymentItem(
        label: 'Payment',
        amount: amount.toString(),
        status: PaymentItemStatus.final_price,
      ),
    ];
  }

  /// Processes the payment using the received token
  Future<void> _processPaymentWithToken({
    required double amount,
    required String terminalId,
    required int merchantId,
    required String transactionId,
    required Map<String, dynamic> result,
  }) async {
    try {
      final purchaseRequest = _createPurchaseRequest(
        result: result,
        amount: amount,
        terminalId: terminalId,
        merchantId: merchantId,
        transactionId: transactionId,
      );

      final networkState =
          await _purchaseAppleSamsungPayUseCase.invoke(purchaseRequest);

      networkState.when(
        initial: () => emit(const ICubitState<DigitalWalletResponse>.loading()),
        success: (response) => _handlePaymentSuccess(response),
        error: (message, errors) =>
            _handlePaymentError(message ?? 'Payment failed'),
      );
    } catch (e) {
      log('Error processing payment with token: $e');
      _handlePaymentError('Failed to process payment: $e');
    }
  }

  /// Creates a purchase request with the payment token
  PurchaseRequest _createPurchaseRequest({
    required double amount,
    required String terminalId,
    required int merchantId,
    required String transactionId,
    required Map<String, dynamic> result,
  }) {
    final request = PurchaseRequest(
      amount: amount,
      terminalId: int.parse(terminalId),
      merchantId: merchantId,
      transactionId: transactionId,
      currencyCode: "512",
      pan: '',
      cardHolderName: '',
      cvV2: '',
      dateExpiration: '',
      orderCustomerEmail: '',
      clientMail: '',
    );

    try {
      if (Platform.isIOS) {
        request.isApplyRequest = true;
        // Extract payment method details
        final paymentMethod = result['paymentMethod'] as Map<String, dynamic>;
        final token = jsonDecode(result['token']) as Map<String, dynamic>;
        // Create the mapped Apple Pay data
        final mappedApplePayData = {
          'applePaymentMethod': {
            'displayName': paymentMethod['displayName'],
            'network': paymentMethod['network'],
            'type': paymentMethod['type'] == 2 ? 'debit' : 'credit'
          },
          'data': token['data'],
          'header': token['header'],
          'signature': token['signature'],
          'version': token['version']
        };

        request.applePayPaymentData = mappedApplePayData;
      } else if (Platform.isAndroid) {
        request.isSamsungPayRequest = true;
        request.samsungPayData = result;
      }
    } catch (e) {
      log('Error parsing payment token: $e');
      // Continue with the request even if token parsing fails
    }

    return request;
  }

  /// Handles successful payment
  void _handlePaymentSuccess(PurchaseResponse response) {
    emit(ICubitState<DigitalWalletResponse>.success(
      uiModel: DigitalWalletResponse(
        message: 'Payment successful',
        status: 'success',
      ),
    ));

    onResponse(response.data?.toMap().toString() ?? '');

    TransactionUtilDialog.showReceiptWithTransactionSettings(
      purchaseData: response.data,
      context: context,
    );
  }

  /// Handles payment errors
  void _handlePaymentError(String errorMessage) {
    log('Payment error: $errorMessage');
    emit(ICubitState<DigitalWalletResponse>.error(
      message: errorMessage,
    ));

    onResponse(errorMessage);
    AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
  }
}
