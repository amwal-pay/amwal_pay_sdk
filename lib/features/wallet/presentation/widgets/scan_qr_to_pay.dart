import 'dart:async';

import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_qr_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/qr_response.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class ScanQrToPayWidget extends StatefulWidget {
  final PaymentArguments paymentArguments;
  final String Function(String)? globalTranslator;
  final OnPayCallback onPay;
  final GetTransactionFunction getTransactionFunction;
  const ScanQrToPayWidget({
    Key? key,
    required this.paymentArguments,
    required this.onPay,
    this.globalTranslator,
    required this.getTransactionFunction,
  }) : super(key: key);

  @override
  State<ScanQrToPayWidget> createState() => _ScanQrToPayWidgetState();
}

class _ScanQrToPayWidgetState extends State<ScanQrToPayWidget> {
  late SaleByQrCubit cubit;
  PaymentArguments get payArgs => widget.paymentArguments;
  Timer? _timer;

  void _setupGetTransactionId(String transactionId) {
    print('potato sdk 0');
    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (timer) async {
        final settings = await widget.getTransactionFunction(transactionId);
        print('potato sdk');
        print(settings);
        if (settings != null) {
          timer.cancel();
          if (context.mounted) {
            await ReceiptHandler.instance.showHistoryReceipt(
              context: context,
              settings: settings.copyWith(
                onClose: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
                },
              ),
            );
          }
        }
      },
    );
  }

  Future<void> _generateQrCode() async {
    final transactionId = const Uuid().v1();
    await cubit.payWithQr(
      transactionId: transactionId,
      merchantId: payArgs.merchantId,
      amount: num.parse(payArgs.amount),
      terminalId: int.parse(payArgs.terminalId),
      currencyId: payArgs.currencyData!.idN,
    );
    _setupGetTransactionId(transactionId);
    widget.onPay((settings) async {
      await ReceiptHandler.instance.showHistoryReceipt(
        context: context,
        settings: settings.copyWith(
          onClose: () {
            Navigator.pop(context);
            Navigator.pop(context);
            AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
          },
        ),
      );
    }, transactionId);
  }

  @override
  void initState() {
    super.initState();
    cubit = WalletInjector.instance.get<SaleByQrCubit>();
    _generateQrCode();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'scan_qr_code_to_pay'.translate(
            context,
            globalTranslator: widget.globalTranslator,
          ),
          style: const TextStyle(
            color: blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        BlocBuilder<SaleByQrCubit, ICubitState<QRResponse>>(
          bloc: cubit,
          builder: (_, state) {
            final qrCodeString = state.mapOrNull(
                  success: (value) => value.uiModel.data,
                ) ??
                '';
            return QrImageView(
              data: qrCodeString,
              size: 200,
            );
          },
        ),
      ],
    );
  }
}
