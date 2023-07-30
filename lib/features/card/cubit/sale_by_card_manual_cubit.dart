import 'package:amwal_pay_sdk/core/apiview/state_mapper.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/card/data/models/request/purchase_request.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SaleByCardManualCubit extends ICubit<PurchaseResponse>
    with UiState<PurchaseResponse> {
  final IUseCase<PurchaseResponse, PurchaseRequest> _purchaseUseCase;
  final IUseCase<PurchaseResponse, PurchaseRequest> _purchaseOtpStepOneUseCase;
  final IUseCase<PurchaseResponse, PurchaseRequest> _purchaseOtpStepTwoUseCase;

  SaleByCardManualCubit(
    this._purchaseUseCase,
    this._purchaseOtpStepOneUseCase,
    this._purchaseOtpStepTwoUseCase,
  );

  final formKey = GlobalKey<FormBuilderState>();

  String? cardHolderName;
  String? cardNo;
  String? cvV2;
  String? expirationDateMonth;
  String? expirationDateYear;
  String? email;
  String? originalTransactionId;

  Future<PurchaseData?> purchase(
    String amount,
    String terminalId,
    int currencyId,
    int merchantId,
    String? transactionId,
  ) async {
    final purchaseRequest = PurchaseRequest(
      pan: cardNo!.replaceAll(' ', ''),
      amount: num.parse(amount),
      terminalId: int.parse(terminalId),
      merchantId: merchantId,
      cardHolderName: cardHolderName!,
      transactionId: transactionId,
      cvV2: cvV2!,
      dateExpiration: '$expirationDateMonth$expirationDateYear',
      requestDateTime: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
      orderCustomerEmail: email!,
      clientMail: email!,
      currencyCode: currencyId.toString(),
    );
    final networkState = await _purchaseUseCase.invoke(purchaseRequest);
    final state = mapNetworkState(networkState);
    emit(state);
    return state.mapOrNull(success: (value) => value.uiModel.data);
  }

  Future<String?> purchaseOtpStepOne(
    String amount,
    String terminalId,
    int currencyId,
    int merchantId,
    String? transactionId,
  ) async {
    emit(const ICubitState.loading());
    final purchaseRequest = PurchaseRequest(
      pan: cardNo!.replaceAll(' ', ''),
      amount: num.parse(amount),
      terminalId: int.parse(terminalId),
      merchantId: merchantId,
      cardHolderName: cardHolderName!,
      cvV2: cvV2!,
      dateExpiration: '$expirationDateMonth$expirationDateYear',
      requestDateTime: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
      orderCustomerEmail: email!,
      transactionId: transactionId,
      clientMail: email!,
      currencyCode: currencyId.toString(),
    );
    final networkState = await _purchaseOtpStepOneUseCase.invoke(
      purchaseRequest,
    );
    final state = mapNetworkState(networkState);
    originalTransactionId =
        state.mapOrNull(success: (value) => value.uiModel.data?.transactionId);
    emit(state);
    return originalTransactionId;
  }

  Future<PurchaseData?> purchaseOtpStepTwo(
    String amount,
    String terminalId,
    int currencyId,
    int merchantId,
    String? transactionId,
    String otp,
  ) async {
    emit(const ICubitState.loading());
    final purchaseRequest = PurchaseRequest(
      pan: cardNo!.replaceAll(' ', ''),
      amount: num.parse(amount),
      terminalId: int.parse(terminalId),
      merchantId: merchantId,
      cardHolderName: cardHolderName!,
      cvV2: cvV2!,
      otp: otp,
      dateExpiration: '$expirationDateMonth$expirationDateYear',
      requestDateTime: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
      orderCustomerEmail: email!,
      clientMail: email!,
      currencyCode: currencyId.toString(),
      originalTransactionIdentifierValue: transactionId,
      originalTransactionIdentifierType: 2,
      transactionId:transactionId
    );
    final networkState =
        await _purchaseOtpStepTwoUseCase.invoke(purchaseRequest);
    final state = mapNetworkState(networkState);
    emit(state);
    return state.mapOrNull(success: (value) => value.uiModel.data);
  }
}
