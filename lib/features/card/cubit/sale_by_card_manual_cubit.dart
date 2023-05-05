import 'package:amwal_pay_sdk/core/apiview/state_mapper.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/card/data/models/request/purchase_request.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SaleByCardManualCubit extends ICubit<PurchaseResponse>
    with UiState<PurchaseResponse>{
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

  Future<PurchaseData?> purchase(String amount, String terminalId) async {
    emit(const ICubitState.loading());
    final purchaseRequest = PurchaseRequest(
      pan: cardNo!,
      amount: num.parse(amount),
      terminalId: int.parse(terminalId),
      merchantId: 0,
      cardHolderName: cardHolderName!,
      cvV2: cvV2!,
      dateExpiration: '$expirationDateMonth/$expirationDateYear',
      requestDateTime: DateTime.now().toString(),
      orderCustomerEmail: email!,
      clientMail: email!,
    );
    final networkState = await _purchaseUseCase.invoke(purchaseRequest);
    final state = mapNetworkState(networkState);
    emit(state);
    formKey.currentState?.reset();
    return state.mapOrNull(success: (value) => value.uiModel.data);
  }

  Future<void> purchaseOtpStepOne(String amount, String terminalId) async {
    emit(const ICubitState.loading());
    final purchaseRequest = PurchaseRequest(
      pan: cardNo!,
      amount: num.parse(amount),
      terminalId: int.parse(terminalId),
      merchantId: 0,
      cardHolderName: cardHolderName!,
      cvV2: cvV2!,
      dateExpiration: '$expirationDateMonth/$expirationDateYear',
      requestDateTime: DateTime.now().toString(),
      orderCustomerEmail: email!,
      clientMail: email!,
    );
    final networkState = await _purchaseOtpStepOneUseCase.invoke(
      purchaseRequest,
    );
    final state = mapNetworkState(networkState);
    formKey.currentState?.reset();
    emit(state);
  }

  Future<PurchaseData?> purchaseOtpStepTwo(
    String amount,
    String terminalId,
    String otp,
  ) async {
    emit(const ICubitState.loading());
    final purchaseRequest = PurchaseRequest(
      pan: cardNo!,
      amount: num.parse(amount),
      terminalId: int.parse(terminalId),
      merchantId: 0,
      cardHolderName: cardHolderName!,
      cvV2: cvV2!,
      otp: otp,
      dateExpiration: '$expirationDateMonth/$expirationDateYear',
      requestDateTime: DateTime.now().toString(),
      orderCustomerEmail: email!,
      clientMail: email!,
    );
    final networkState =
        await _purchaseOtpStepTwoUseCase.invoke(purchaseRequest);
    final state = mapNetworkState(networkState);
    emit(state);
    return state.mapOrNull(success: (value) => value.uiModel.data);
  }
}
