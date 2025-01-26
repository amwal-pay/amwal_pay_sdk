import 'dart:async';

import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_setting_container.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/transaction/data/models/response/one_transaction_response.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/use_case/get_transaction_by_Id.dart';
import 'package:amwal_pay_sdk/features/transaction/util.dart';
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
  final EventCallback? log;
  const ScanQrToPayWidget({
    Key? key,
    required this.paymentArguments,
    required this.onPay,
    this.globalTranslator,
    required this.getTransactionFunction,
    this.log,
  }) : super(key: key);

  @override
  State<ScanQrToPayWidget> createState() => _ScanQrToPayWidgetState();
}

class _ScanQrToPayWidgetState extends State<ScanQrToPayWidget> {
  late SaleByQrCubit cubit;
  PaymentArguments get payArgs => widget.paymentArguments;
  Timer? _timer;

  TransactionDetailsSettings _generateTransactionSettings(
    OneTransaction oneTransaction,
    BuildContext context,
  ) {
    return TransactionDetailsSettings(
      locale: AmwalSdkSettingContainer.locale,
      amount: oneTransaction.amount,
      transactionDisplayName: oneTransaction.transactionTypeDisplayName ?? '',
      isSuccess: oneTransaction.responseCodeName == 'Approved',
      transactionStatus: oneTransaction.responseCodeName == 'Approved'
          ? TransactionStatus.success
          : TransactionStatus.failed,
      transactionType: oneTransaction.transactionType ?? '',
      isTransactionDetails: false,
      globalTranslator: (string) => string.translate(context),
      details: {
        'merchant_name_label': oneTransaction.merchantName,
        'ref_no': oneTransaction.idN,
        'merchant_id': oneTransaction.merchantId,
        'terminal_id': oneTransaction.terminalId,
        'date_time': oneTransaction.transactionTime?.formatDate(context),
        'amount': oneTransaction.transactionAmount(context),
      },
    );
  }

  Future<TransactionDetailsSettings?> _getTransactionById(
    String transactionId,
  ) async {
    final oneTransactionResponse = await WalletInjector.instance
        .get<GetOneTransactionByIdUseCase>()
        .invoke({
      'transactionId': transactionId,
      'merchantId': payArgs.merchantId,
    });
    final oneTransaction =
        oneTransactionResponse.mapOrNull(success: (value) => value.data.data);
    if (oneTransaction == null) return null;
    if (!context.mounted) return null;
    return _generateTransactionSettings(
      oneTransaction,
      context,
    );
  }

  void _setupGetTransactionId() {
    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (timer) async {
        TransactionDetailsSettings? settings;
        final transactionId = cubit.state.mapOrNull(
              success: (value) => value.uiModel.data?.walletOrderId,
            ) ??
            '';
        if (transactionId.isEmpty) return;
        if (SDKNetworkConstants.isSdkInApp) {
          settings = await _getTransactionById(transactionId);
        } else {
          settings = await widget.getTransactionFunction(transactionId);
        }
        if (settings != null) {
          timer.cancel();
          if (context.mounted) {
            if (settings.isSuccess) {
              widget.log?.call('payment_successful', {
                'user_id': payArgs.merchantId,
                'transaction_id': transactionId,
                'payment_amount': payArgs.amount,
                'payment_method': 'Dynamic Qr',
                'currency': payArgs.currencyData!.name,
              });
            }
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
    _setupGetTransactionId();
    widget.log?.call('payment_initiated', {
      'user_id': payArgs.merchantId,
      'payment_amount': payArgs.amount,
      'payment_method': 'Dynamic Qr',
      'currency': payArgs.currencyData!.name,
    });
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
            final qrData = state.mapOrNull(
              success: (value) => value.uiModel.data,
            );
            state.mapOrNull(error: (_) {
              widget.log?.call('payment_failed', {
                "user_id": payArgs.merchantId,
                "transaction_id": payArgs.transactionId,
                "payment_amount": payArgs.amount,
                "payment_method": 'Dynamic Qr',
                "failed_reason": _.message,
                "currency": payArgs.currencyData?.name ?? '',
              });
            });
            return QrImageView(
              data: qrData?.qrCode ?? '',
              size: 200,
            );
          },
        ),
      ],
    );
  }
}
