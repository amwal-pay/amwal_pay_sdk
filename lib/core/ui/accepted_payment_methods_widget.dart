import 'package:amwal_pay_sdk/core/resources/assets/app_assets_paths.dart';
import 'package:flutter/material.dart';

class AcceptedPaymentMethodsWidget extends StatelessWidget {
  final bool showExpress;
  final bool showVisa;
  final bool showMaster;
  final bool showOmanNet;
  const AcceptedPaymentMethodsWidget({
    Key? key,
    this.showExpress = true,
    this.showVisa = true,
    this.showMaster = true,
    this.showOmanNet = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showVisa) Image.asset(AppAssets.visaLogo, package: 'amwal_pay_sdk'),
        const SizedBox(
          width: 4,
        ),
        if (showMaster)
          Image.asset(
            AppAssets.masterLogo,
            package: 'amwal_pay_sdk',
          ),
        const SizedBox(
          width: 4,
        ),
        if (showOmanNet)
          Image.asset(

            AppAssets.omanNetLogo,
            package: 'amwal_pay_sdk',
            width: 40,
          ),
        const SizedBox(
          width: 4,
        ),
        if (showExpress)
          Image.asset(
            AppAssets.expressLogo,
            package: 'amwal_pay_sdk',
          ),
      ],
    );
  }
}
