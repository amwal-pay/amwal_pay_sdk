

import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_verify_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/request/verification_request.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/widgets/sale_by_wallet_mixins/sale_by_wallet_action_mixin.dart';

mixin SaleByWalletVerifyMixin on SaleByWalletActionsMixin {
  WalletMobileVerificationRequest _generateVerifyCustomerRequest(
    PaymentArguments paymentArguments,
  ) {
    final request = WalletMobileVerificationRequest(
      mobileNumber: cubit.phoneNumber,
      alias: cubit.aliasName,
      amount: num.parse(paymentArguments.amount),
      currencyId: paymentArguments.currencyData?.idN ?? 512,
      terminalId: paymentArguments.terminalId,
      merchantId: paymentArguments.merchantId,
      id: paymentArguments.transactionId,
    );
    return request;
  }

  Future<void> verifyCustomer({
    required SaleByWalletVerifyCubit verifyCubit,
    required PaymentArguments paymentArguments,
  }) async {
    if (cubit.formKey.currentState!.validate()) {
      final request = _generateVerifyCustomerRequest(paymentArguments);
      await verifyCubit.verifyCustomer(request);
    }
  }
}
