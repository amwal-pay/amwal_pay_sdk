import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/ui/buttons/app_button.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_pay_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_verify_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/verify_customer_response.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/wallet_pay_response.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/widgets/sale_by_wallet_mixins/sale_by_wallet_action_mixin.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/widgets/sale_by_wallet_mixins/sale_by_wallet_pay_mixin.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/widgets/sale_by_wallet_mixins/sale_by_wallet_verify_mixin.dart';
import 'package:amwal_pay_sdk/features/wallet/state/sale_by_wallet_state.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaleActionButtons extends ApiView<SaleByWalletCubit>
    with
        SaleByWalletActionsMixin,
        SaleByWalletVerifyMixin,
        SaleByWalletPayMixin {
  const SaleActionButtons({
    Key? key,
    required this.onPay,
    required this.onCountComplete,
    required this.paymentArguments,
    required this.countDownInSeconds,
    this.globalTranslator,
  }) : super(key: key);
  final PaymentArguments paymentArguments;
  final OnPayCallback onPay;
  final OnPayCallback onCountComplete;
  final String Function(String)? globalTranslator;
  final int countDownInSeconds;

  @override
  Widget build(BuildContext context) {
    final verifyCubit = WalletInjector.instance.get<SaleByWalletVerifyCubit>();
    final payCubit = WalletInjector.instance.get<SaleByWalletPayCubit>();
    final walletCubit = WalletInjector.instance.get<SaleByWalletCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<SaleByWalletVerifyCubit,
            ICubitState<VerifyCustomerResponse>>(
          bloc: verifyCubit,
          listener: (_, state) => state.whenOrNull(
            success: (value) {
              if (value.success) {
                cubit.customerNameFromApi = value.data?.customerName ?? "";
                return cubit.verified();
              } else {
                return;
              }
            },
          ),
        ),
        BlocListener<SaleByWalletPayCubit, ICubitState<WalletPayResponse>>(
          bloc: payCubit,
          listener: (_, state) async {
            final isSuccess = state.mapOrNull(
              success: (value) => true,
            );
            if (isSuccess == true) {
              walletCubit.reset();
              await showCountingDialog(
                context,
                globalTranslator,
                onPay,
                onCountComplete,
                paymentArguments.currencyData!.name.translate(
                  context,
                  globalTranslator: globalTranslator,
                ),
                paymentArguments.transactionId!,
                paymentArguments.merchantId,
                countDownInSeconds,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<SaleByWalletCubit, SaleByWalletState>(
        bloc: cubit,
        builder: (_, state) {
          if (cubit.state.page == 2) {
            return const SizedBox();
          } else if (cubit.state.verified) {
            return Row(
              children: [
                const SizedBox(width: 24),
                Expanded(
                  child: AppOutlineButton(
                    onPressed: cubit.reset,
                    title: 'cancel'.translate(
                      context,
                      globalTranslator: globalTranslator,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: AppButton.small(
                    onPressed: () async => await pay(
                      page: state.page,
                      payCubit: payCubit,
                      paymentArguments: paymentArguments,
                      alias: cubit.aliasName??'',
                      mobileNumber: cubit.phoneNumber??'',
                    ),
                    child: Text(
                      'pay'.translate(
                        context,
                        globalTranslator: globalTranslator,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
            );
          } else {
            return AppButton(
              onPressed: () async => await verifyCustomer(
                verifyCubit: verifyCubit,
                paymentArguments: paymentArguments,
              ),
              child: Text(
                'verify'.translate(
                  context,
                  globalTranslator: globalTranslator,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
