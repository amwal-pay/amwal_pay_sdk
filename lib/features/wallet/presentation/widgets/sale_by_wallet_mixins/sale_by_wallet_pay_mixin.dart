import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_pay_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/request/payment_request.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/widgets/sale_by_wallet_mixins/sale_by_wallet_action_mixin.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:uuid/uuid.dart';

mixin SaleByWalletPayMixin on SaleByWalletActionsMixin {
  WalletPaymentRequest _generatePayRequest(
    PaymentArguments paymentArguments,
    String alias,
    String mobileNumber,
  ) {
    final request = WalletPaymentRequest(
      currencyId: paymentArguments.currencyData!.idN,
      amount: num.parse(paymentArguments.amount),
      merchantId: paymentArguments.merchantId,
      terminalId: paymentArguments.terminalId,
      id: paymentArguments.transactionId!,
      mobileNumber: mobileNumber,
      aliasName: alias,
      transactionId: const Uuid().v1(),
    );
    return request;
  }

  Future<void> pay({
    required int page,
    required SaleByWalletPayCubit payCubit,
    required PaymentArguments paymentArguments,
    required String alias,
    required String mobileNumber,
    EventCallback? log,
  }) async {
    if (page == 2) {
      return;
    } else {
      log?.call('payment_initiated', {
        'user_id': paymentArguments.merchantId,
        'payment_amount': paymentArguments.amount,
        'payment_method': 'Pay by Wallet',
        'currency': paymentArguments.currencyData!.name,
      });
      final request = _generatePayRequest(
        paymentArguments,
        alias,
        mobileNumber,
      );
      if (page == 0) {
        await payCubit.payWithMobile(request);
      } else {
        await payCubit.payByAlias(request);
      }
    }
  }
}
