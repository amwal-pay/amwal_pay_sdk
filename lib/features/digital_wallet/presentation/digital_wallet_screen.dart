import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/features/digital_wallet/cubit/sale_by_digital_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/digital_wallet/model/digital_wallet_response.dart';
import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/features/digital_wallet/constants/digital_wallet_translations.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';

import '../../wallet/dependency/injector.dart';

class DigitalWalletScreen extends StatefulApiView<SaleByDigitalWalletCubit> {
  final Function(String) onResponse;
  final Function() dismissDialog;
  final Function(String) log;
  final double amount;
  final String terminalId;
  final String currency;
  final int currencyId;
  final int merchantId;
  final String transactionId;

  const DigitalWalletScreen({
    Key? key,
    required this.onResponse,
    required this.dismissDialog,
    required this.log,
    required this.amount,
    required this.terminalId,
    required this.currency,
    required this.currencyId,
    required this.merchantId,
    required this.transactionId,
  }) : super(key: key);

  @override
  State<DigitalWalletScreen> createState() => _DigitalWalletScreenState();
}

class _DigitalWalletScreenState extends State<DigitalWalletScreen> {
  late SaleByDigitalWalletCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = WalletInjector.instance.getIt<SaleByDigitalWalletCubit>();
    _processPayment();
  }

  Future<void> _processPayment() async {
    await _cubit.processDigitalWalletPayment(
      amount: widget.amount,
      terminalId: widget.terminalId,
      currency: widget.currency,
      currencyId: widget.currencyId,
      merchantId: widget.merchantId,
      transactionId: widget.transactionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGeryColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: widget.dismissDialog,
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: blackColor,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.apple,
              color: blackColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              DigitalWalletTranslations.applePay.translate(context),
              style: const TextStyle(
                color: blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<SaleByDigitalWalletCubit,
          ICubitState<DigitalWalletResponse>>(
        bloc: _cubit,
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox(),
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    DigitalWalletTranslations.processingPayment
                        .translate(context),
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            success: (data) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    DigitalWalletTranslations.paymentSuccessful
                        .translate(context),
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DigitalWalletTranslations.thankYouForPayment
                        .translate(context),
                    style: const TextStyle(
                      color: greyColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            error: (message, errorList) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: redColor,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${DigitalWalletTranslations.paymentError.translate(context)}: $message',
                    style: const TextStyle(
                      color: redColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (errorList != null && errorList.isNotEmpty)
                    ...errorList.map((error) => Text(
                          error,
                          style: const TextStyle(
                            color: greyColor,
                            fontSize: 14,
                          ),
                        )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
