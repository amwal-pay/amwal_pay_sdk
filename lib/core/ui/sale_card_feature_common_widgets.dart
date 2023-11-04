import 'package:amwal_pay_sdk/core/merchant_store/merchant_store.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';

import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';

class SaleCardFeatureCommonWidgets {
  static Widget merchantAndAmountInfo(
    BuildContext context,
    PaymentArguments paymentArgs, {
    String Function(String)? translator,
  }) {
    final merchantName = MerchantStore.instance.getMerchantName();
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'merchant_name_label'.translate(
                      context,
                      globalTranslator: translator,
                    ),
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    merchantName ?? 'Merchant Name',
                    style: const TextStyle(
                      color: blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'amount_label'.translate(
                      context,
                      globalTranslator: translator,
                    ),
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        paymentArgs.currencyData!.name.translate(
                          context,
                          globalTranslator: translator,
                        ),
                        style: const TextStyle(
                          color: greyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        paymentArgs.amount,
                        style: const TextStyle(
                          color: blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
