import 'package:amwal_pay_sdk/core/resources/assets/app_assets_paths.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/directional_widget/directional_widget.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_detail_widget.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_dialog_action_buttons.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class TransactionStatusDialog extends StatefulWidget {
  final TransactionDetailsSettings settings;

  const TransactionStatusDialog({
    Key? key,
   required this.settings,
  }) : super(key: key);

  @override
  State<TransactionStatusDialog> createState() =>
      _TransactionStatusDialogState();
}

class _TransactionStatusDialogState extends State<TransactionStatusDialog> {
  late ScreenshotController _screenshotController;
  TransactionDetailsSettings get settings => widget.settings;
  bool _isSharing = false;
  @override
  void initState() {
    super.initState();
    _screenshotController = ScreenshotController();
  }

  Future<void> _share() async {
    setState(() => _isSharing = true);
    final screenshotData = await _screenshotController.capture();
    setState(() => _isSharing = false);
    if (screenshotData != null) {
      final file = XFile.fromData(
        screenshotData,
        mimeType: 'jpg',
      );
      await Share.shareXFiles(
        [
          file,
        ],
      );
    }
  }

  Widget dialog({bool forShare = false}) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(
          top: 40,
          bottom: 20,
        ),
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              settings.transactionStatus.transactionStatusImage,
              const SizedBox(
                height: 10,
              ),
              Text(
                settings.transactionStatus.transactionStatusTitle.translate(
                  context,
                  globalTranslator: settings.globalTranslator,
                ),
                style: const TextStyle(
                  color: blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                settings.transactionType,
                style: const TextStyle(
                  color: greyColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DirectionalWidget(
                    child: Image.asset(
                      AppAssets.divCircleLeft,
                      package: 'amwal_pay_sdk',
                      color: greyColor,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Dash(
                        length: size.width * .72,
                        direction: Axis.horizontal,
                        dashColor: greyColor,
                      ),
                    ),
                  ),
                  DirectionalWidget(
                    child: Image.asset(
                      AppAssets.divCircleRight,
                      package: 'amwal_pay_sdk',
                      color: greyColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...settings.details?.keys.map<Widget>(
                    (title) {
                      final value = settings.details![title].toString();
                      return TransactionDetailWidget(
                        title: title,
                        value: value,
                      );
                    },
                  ).toList() ??
                  const [],
              const SizedBox(
                height: 27,
              ),
              if (!forShare)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: TransactionDialogAction.build(
                    settings.isTransactionDetails,
                    _share,
                    onClose: settings.onClose,
                    isRefunded: settings.isRefunded,
                    isCaptured: settings.isCaptured,
                    isSettled: settings.isSettled,
                    globalTranslator: settings.globalTranslator,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: dialog(
        forShare: _isSharing
      ),
    );
  }
}

extension TransactionX on TransactionStatus {
  Widget get transactionStatusImage {
    if (this == TransactionStatus.success) {
      return SvgPicture.asset(
        AppAssets.successIcon,
        package: 'amwal_pay_sdk',
      );
    } else {
      return SvgPicture.asset(
        AppAssets.errorIcon,
        package: 'amwal_pay_sdk',
      );
    }
  }

  String get transactionStatusTitle {
    if (this == TransactionStatus.success) {
      return 'transaction_success';
    } else {
      return 'transaction_failed';
    }
  }
}
