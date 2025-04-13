import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/features/digital_wallet/cubit/sale_by_digital_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/digital_wallet/model/digital_wallet_response.dart';
import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';

import '../../wallet/dependency/injector.dart';

class SaleByApplePayScreen extends StatefulApiView<SaleByDigitalWalletCubit> {
  final Function(String) onResponse;
  final Function() dismissDialog;
  final Function(String) log;
  final double amount;
  final String terminalId;
  final String currency;
  final int currencyId;
  final int merchantId;
  final String transactionId;

  const SaleByApplePayScreen({
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
  State<SaleByApplePayScreen> createState() => _SaleByApplePayScreenState();
}

class _SaleByApplePayScreenState extends State<SaleByApplePayScreen> {
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
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.apple,
              color: blackColor,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Apple Pay',
              style: TextStyle(
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
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Processing your payment...',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            success: (data) => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Payment Successful!',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Thank you for your payment.',
                    style: TextStyle(
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
                    'Error: $message',
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
