import 'dart:convert';
import 'dart:io';

import 'package:amwal_pay_sdk/core/apiview/state_mapper.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/digital_wallet/model/digital_wallet_response.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:flutter/material.dart';

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


// State classes
abstract class SaleByDigitalWalletState {}

class SaleByDigitalWalletLoading extends SaleByDigitalWalletState {}

class SaleByDigitalWalletSuccess extends SaleByDigitalWalletState {}

class SaleByDigitalWalletError extends SaleByDigitalWalletState {
  final String message;

  SaleByDigitalWalletError(this.message);
}

/// Cubit responsible for handling digital wallet payment operations
class SaleByDigitalWalletCubit extends ICubit<DigitalWalletResponse>
    with UiState<DigitalWalletResponse> {
  final FlutterPay _flutterPay;
  final BuildContext context;
  final Function(String) onResponse;
  final Function() dismissDialog;
  final Function(String) log;
  final PurchaseAppleSamsungPayUseCase _purchaseAppleSamsungPayUseCase;

  SaleByDigitalWalletCubit({
    required this.context,
    required this.onResponse,
    required this.dismissDialog,
    required this.log,
    required PurchaseAppleSamsungPayUseCase purchaseAppleSamsungPayUseCase,
  })  : _flutterPay = FlutterPay(),
        _purchaseAppleSamsungPayUseCase = purchaseAppleSamsungPayUseCase;

  /// Checks if digital wallet payments are available on the device
  Future<bool> canMakePayments() async {
    return await _flutterPay.canMakePayments();
  }

  /// Checks if the device has active cards for digital wallet payments
  Future<bool> canMakePaymentsWithActiveCard() async {
    return await _flutterPay.canMakePaymentsWithActiveCard(
      allowedPaymentNetworks: DigitalWalletConstants.supportedNetworks,
    );
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

      _configurePaymentEnvironment();

      if (!await _validateActiveCards()) {
        return;
      }

      final token = await _requestPaymentToken(
        amount: amount,
        merchantId: merchantId,
      );

      if (token.isEmpty) {
        _handlePaymentError('Failed to get payment token');
        return;
      }

      await _processPaymentWithToken(
        token: token,
        amount: amount,
        terminalId: terminalId,
        merchantId: merchantId,
        transactionId: transactionId,
      );
    } catch (e) {
      _handlePaymentError('An unexpected error occurred');
    }
  }

  /// Validates if digital wallet payments are available
  Future<bool> _validateDigitalWalletAvailability() async {
    bool isAvailable = await _flutterPay.canMakePayments();
    if (!isAvailable) {
      _handlePaymentError(
          'Digital wallet payments are not available on this device');
      return false;
    }
    return true;
  }

  /// Configures the payment environment
  void _configurePaymentEnvironment() {
    _flutterPay.setEnvironment(environment: PaymentEnvironment.Test);
  }

  /// Validates if the device has active cards
  Future<bool> _validateActiveCards() async {
    bool hasActiveCards = await _flutterPay.canMakePaymentsWithActiveCard(
      allowedPaymentNetworks: DigitalWalletConstants.supportedNetworks,
    );
    if (!hasActiveCards) {
      _handlePaymentError('No active cards found for digital wallet payment');
      return false;
    }
    return true;
  }

  /// Requests a payment token from the digital wallet
  Future<String> _requestPaymentToken({
    required double amount,
    required int merchantId,
  }) async {
    final paymentItem = PaymentItem(
      name: "Payment",
      price: amount,
    );



    return await _flutterPay.requestPayment(
      googleParameters: GoogleParameters(
        gatewayName: "amwal",
        gatewayMerchantId: merchantId.toString(),
        merchantId: merchantId.toString(),
        merchantName: DigitalWalletConstants.merchantName,
      ),
      appleParameters: AppleParameters(
        merchantIdentifier: DigitalWalletConstants.merchantIdentifier,
      ),
      currencyCode: DigitalWalletConstants.currencyCode,
      countryCode: DigitalWalletConstants.countryCode,
      paymentItems: [paymentItem],
    );
  }

  /// Processes the payment using the received token
  Future<void> _processPaymentWithToken({
    required String token,
    required double amount,
    required String terminalId,
    required int merchantId,
    required String transactionId,
  }) async {
    final purchaseRequest = _createPurchaseRequest(
      token: token,
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
  }

  /// Creates a purchase request with the payment token
  PurchaseRequest _createPurchaseRequest({
    required String token,
    required double amount,
    required String terminalId,
    required int merchantId,
    required String transactionId,
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

    if (Platform.isIOS) {
      request.isApplyRequest = true;
      request.applePayPaymentData = jsonDecode(token) as Map<String, dynamic>;
    } else if (Platform.isAndroid) {
      request.isSamsungPayRequest = true;
      request.samsungPayData = jsonDecode(token) as Map<String, dynamic>;
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
    emit(ICubitState<DigitalWalletResponse>.error(
      message: errorMessage,
    ));

    onResponse(errorMessage);
    AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
  }
}
