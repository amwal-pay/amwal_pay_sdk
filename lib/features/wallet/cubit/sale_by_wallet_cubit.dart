import 'package:amwal_pay_sdk/features/wallet/state/sale_by_wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SaleByWalletCubit extends Cubit<SaleByWalletState> {
  SaleByWalletCubit() : super(const SaleByWalletState.initial(0));

  void updatePage(int page) => emit(SaleByWalletState.initial(page));

  void onCancel() => emit(SaleByWalletState.initial(state.page));

  void init() => emit(const SaleByWalletState.initial(0));

  final formKey = GlobalKey<FormBuilderState>();

  String phoneNumber = '';
  String aliasName = '';
  String transactionId = '';

  void verified() => emit(SaleByWalletState.verified(state.page));
}
