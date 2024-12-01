import 'package:amwal_pay_sdk/core/apiview/state_mapper.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/card/data/models/request/customer_token_request.dart';
import 'package:amwal_pay_sdk/features/card/data/models/request/purchase_request.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/customer_token_response.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/card/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/card/presentation/widgets/select_card_bottom_sheet.dart';
import 'package:amwal_pay_sdk/features/card/transaction_manager/in_app_card_transaction_manager.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/use_case/get_transaction_by_Id.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../navigator/sdk_navigator.dart';

class SaleByCardManualCubit extends ICubit<PurchaseResponse>
    with UiState<PurchaseResponse> {
  final IUseCase<PurchaseResponse, PurchaseRequest> _purchaseUseCase;
  final IUseCase<PurchaseResponse, PurchaseRequest> _purchaseOtpStepOneUseCase;
  final IUseCase<PurchaseResponse, PurchaseRequest> _purchaseOtpStepTwoUseCase;
  final IUseCase<PurchaseResponse, PurchaseRequest> _purchaseWithToken;
  final IUseCase<CustomerTokenResponse, CustomerTokenRequest>?
      _getCustomerTokensUseCase;

  SaleByCardManualCubit(
    this._purchaseUseCase,
    this._purchaseOtpStepOneUseCase,
    this._purchaseOtpStepTwoUseCase,
    this._purchaseWithToken,
    this._getCustomerTokensUseCase,
  );

  final formKey = GlobalKey<FormBuilderState>();

  String? cardHolderName;
  String? cardNo;
  String? cvV2;
  String? expirationDateMonth;
  String? expirationDateYear;
  String? email;
  String? originalTransactionId;

  bool isTokenized = true;
  CustomerToken? customerToken;

  String? _validateExpDate() {
    final date = DateTime.now();
    if ((date.month > int.parse(expirationDateMonth!)) &&
        ((date.year % 100) >= int.parse(expirationDateYear!))) {
      return 'invalid_exp_date';
    } else {
      return null;
    }
  }

  void _showErrorSnackBar({
    required BuildContext context,
    required String message,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: redColor,
    );
    scaffoldMessenger.showSnackBar(snackBar);
  }

  Future<PurchaseData?> purchase(
    String amount,
    String terminalId,
    int currencyId,
    int merchantId,
    String? transactionId,
    BuildContext? context,
  ) async {
    String? valid;
    if (customerToken == null) {
      valid = _validateExpDate();
      if (valid != null) {
        if (context != null && context.mounted) {
          _showErrorSnackBar(
              context: context, message: valid.translate(context));
        }
        return null;
      }
    }

    final purchaseRequest = PurchaseRequest(
      pan: cardNo!.replaceAll(' ', ''),
      amount: num.parse(amount),
      terminalId: int.parse(terminalId),
      merchantId: merchantId,
      cardHolderName: cardHolderName!,
      transactionId: transactionId,
      cvV2: cvV2!,
      dateExpiration: '$expirationDateMonth$expirationDateYear',
      orderCustomerEmail: email ?? "",
      clientMail: email ?? "",
      currencyCode: currencyId.toString(),
    );
    final networkState = await _purchaseUseCase.invoke(purchaseRequest);
    final state = mapNetworkState(networkState);
    emit(state);
    return state.mapOrNull(success: (value) => value.uiModel.data);
  }

  Future<PurchaseData?> purchaseOtpStepOne(
    String amount,
    String terminalId,
    int currencyId,
    int merchantId,
    String? transactionId,
    BuildContext? context, {
    bool isTokenized = false,
    void Function(void Function())? dismissLoaderTrigger,
  }) async {
    String? valid;
    if (customerToken == null) {
      valid = _validateExpDate();
      if (valid != null) {
        if (context != null && context.mounted) {
          _showErrorSnackBar(
              context: context, message: valid.translate(context));
        }
        return null;
      }
    }

    emit(const ICubitState.loading());
    final purchaseRequest = PurchaseRequest(
      pan: cardNo!.replaceAll(' ', ''),
      amount: num.parse(amount),
      terminalId: int.parse(terminalId),
      merchantId: merchantId,
      cardHolderName: cardHolderName!,
      cvV2: cvV2 ?? "",
      dateExpiration: '$expirationDateMonth$expirationDateYear',
      orderCustomerEmail: email ?? "",
      transactionId: transactionId,
      clientMail: email ?? "",
      currencyCode: currencyId.toString(),
      isTokenized: isTokenized,
    );
    final networkState = await _purchaseOtpStepOneUseCase.invoke(
      purchaseRequest,
    );
    final state = mapNetworkState(networkState);
    final purchaseData = state.mapOrNull(
      success: (value) => value.uiModel.data,
      error: (value) {
        if (context != null && context.mounted) {
          AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
        }
        return null;
      },
    );

    if (dismissLoaderTrigger == null) {
      emit(state);
    } else {
      dismissLoaderTrigger(() => emit(state));
    }
    return purchaseData;
  }

  Future<PurchaseData?> payWithToken(
    String amount,
    String terminalId,
    int currencyId,
    int merchantId,
    String? transactionId,
    BuildContext? context, {
    bool isTokenized = false,
    String? customerId,
    String? customerTokenId,
    String? cvv,
    void Function(void Function())? dismissLoaderTrigger,
  }) async {
    emit(const ICubitState.loading());
    final purchaseRequest = PurchaseRequest(
      pan: '',
      amount: num.parse(amount),
      terminalId: int.parse(terminalId),
      merchantId: merchantId,
      cardHolderName: '',
      cvV2: cvv ?? "",
      dateExpiration: '',
      orderCustomerEmail: email ?? "",
      transactionId: transactionId,
      clientMail: email ?? "",
      currencyCode: currencyId.toString(),
      customerId: customerId,
      customerTokenId: customerTokenId,
    );
    final networkState = await _purchaseWithToken.invoke(
      purchaseRequest,
    );
    final state = mapNetworkState(networkState);
    final purchaseData = state.mapOrNull(
      success: (value) => value.uiModel.data,
      error: (value) {
        if (context != null && context.mounted) {
          AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
        }
        return null;
      },
    );

    if (dismissLoaderTrigger == null) {
      emit(state);
    } else {
      dismissLoaderTrigger(() => emit(state));
    }
    return purchaseData;
  }

  Future<Either<Map<String, dynamic>, PurchaseData>> purchaseOtpStepTwo(
    String amount,
    String terminalId,
    int currencyId,
    int merchantId,
    String? transactionId,
    String otp,
    String originTransactionId,
    bool isTokenized,
  ) async {
    emit(const ICubitState.loading());
    final purchaseRequest = PurchaseRequest(
      pan: cardNo!.replaceAll(' ', ''),
      amount: num.parse(amount),
      terminalId: int.parse(terminalId),
      merchantId: merchantId,
      cardHolderName: cardHolderName!,
      cvV2: cvV2 ?? "",
      otp: otp,
      dateExpiration: '$expirationDateMonth$expirationDateYear',
      orderCustomerEmail: email ?? "",
      clientMail: email ?? "",
      currencyCode: currencyId.toString(),
      transactionIdentifierValue: originTransactionId,
      transactionIdentifierType: 2,
      transactionId: transactionId,
      isTokenized: isTokenized,
    );
    final networkState =
        await _purchaseOtpStepTwoUseCase.invoke(purchaseRequest);
    final state = mapNetworkState(networkState);
    emit(state);
    final result = state.mapOrNull<Either<Map<String, dynamic>, PurchaseData>>(
      success: (value) => right(value.uiModel.data!),
      error: (value) => left({
        'message': value.message,
        'errorList': value.errorListMsg,
      }),
    );
    if (result == null) {
      return left({'message': 'something went wrong'});
    } else {
      return result;
    }
  }

  Future<void> getCustomerTokens(
    BuildContext context,
    void Function(void Function(BuildContext)) setContext,
    OnPayCallback onPay,
    EventCallback? log,
    void Function(String?)? customerCallback,
    PaymentArguments args,
    String? customerId,
  ) async {
    final response = await _getCustomerTokensUseCase?.invoke(
      const CustomerTokenRequest(),
    );
    if (response == null) return;
    final tokenResponse = response.mapOrNull(
      success: (v) => v.data,
    );
    if (tokenResponse?.data?.isEmpty ?? true) return;

    showBottomSheet(
      context: context.mounted ? context : context,
      enableDrag: false,
      builder: (_) => SelectCardBottomSheet(
        tokens: tokenResponse!.data!,
        initialValue: customerToken,
        onConfirm: (token, cvv) async {
          customerToken = token;
          if (token == null) return;
          if (NetworkConstants.isSdkInApp) {
            await InAppCardTransactionManager(
              customerId: customerId,
              customerTokenId: customerToken?.customerTokenId,
              customerCallback: customerCallback,
              context: context,
              paymentArguments: args,
              saleByCardManualCubit: this,
              onPay: onPay,
              cvv: cvv,
              log: log,
              getOneTransactionByIdUseCase:
                  CardInjector.instance.get<GetOneTransactionByIdUseCase>(),
            ).onPurchaseWith3DS(
              dismissLoader: (ctx1) => Navigator.of(ctx1).pop(),
              token: customerToken,
              setContext: setContext,
            );
          }
        },
      ),
    );
  }

  void showLoader() => emit(const ICubitState.loading());

  void initial() => emit(const ICubitState.initial());
}
