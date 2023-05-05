import 'package:amwal_pay_sdk/core/resources/assets/app_assets_paths.dart';
import 'package:flutter/material.dart';

class AcceptedPaymentMethodsWidget extends StatelessWidget {
  const AcceptedPaymentMethodsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppAssets.visaLogo),
        const SizedBox(
          width: 4,
        ),
        Image.asset(
          AppAssets.masterLogo,

        ),
        const SizedBox(
          width: 4,
        ),
        Image.asset(
          AppAssets.omanNetLogo,

        ),
        const SizedBox(
          width: 4,
        ),
        Image.asset(
          AppAssets.expressLogo,

        ),
      ],
    );
  }
}
