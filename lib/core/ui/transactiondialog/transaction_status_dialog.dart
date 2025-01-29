import 'package:amwal_pay_sdk/core/resources/assets/app_assets_paths.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/directional_widget/directional_widget.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_detail_widget.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_dialog_action_buttons.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

final GlobalKey<State> dialogKey = GlobalKey<State>();

class TransactionStatusDialog extends StatefulWidget {
  final TransactionDetailsSettings settings;
  final EventCallback? log;

  const TransactionStatusDialog({
    Key? key,
    required this.settings,
    this.log,
  }) : super(key: key);

  @override
  State<TransactionStatusDialog> createState() =>
      _TransactionStatusDialogState();
}

class _TransactionStatusDialogState extends State<TransactionStatusDialog> {
  late ScreenshotController _screenshotController;

  TransactionDetailsSettings get settings => widget.settings;
  late Map<String, dynamic> dialogDetails;
  Map<String, dynamic>? dueAmount;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _screenshotController = ScreenshotController();
    extractDueAmount();
  }

  void extractDueAmount() {
    final dueAmountKey = 'due_amount'.translate(
      context,
      globalTranslator: settings.globalTranslator,
    );
    final containsDueAmount = settings.details!.containsKey(dueAmountKey);
    dialogDetails = settings.details!;
    if (containsDueAmount) {
      dueAmount = {dueAmountKey: dialogDetails[dueAmountKey]};
      dialogDetails.remove(dueAmountKey);
    }
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

      final shareResult = await Share.shareXFiles(
        [
          file,
        ],
      );
      if (shareResult.status == ShareResultStatus.success) {
        widget.log?.call('transaction_shared', {
          'user_id': settings.details?['merchant_id'],
          'transaction_id': settings.transactionId,
        });
      }
    }
  }

  Widget dialog({bool forShare = false}) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      key: dialogKey,
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
        width: size.width * 0.95,
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
                settings.transactionDisplayName,
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
                    locale: settings.locale,
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
                    locale: settings.locale,
                    child: Image.asset(
                      AppAssets.divCircleRight,
                      package: 'amwal_pay_sdk',
                      color: greyColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...settings.details?.entries
                      .where((entry) =>
                          entry.value != null &&
                          entry.value.toString().isNotEmpty)
                      .map<Widget>(
                    (entry) {
                      final title = entry.key;
                      final value = entry.value.toString();
                      return TransactionDetailWidget(
                        title: title,
                        value: value,
                      );
                    },
                  ).toList() ??
                  const [],
              if (dueAmount != null)
                const Divider(
                  endIndent: 20,
                  indent: 20,
                  height: 1,
                  thickness: 0.8,
                ),
              const SizedBox(height: 16),
              if (dueAmount != null)
                TransactionDetailWidget(
                  title: dueAmount!.keys.first,
                  value: dueAmount!.values.first,
                  titleStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: darkBlue,
                  ),
                  valueStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: darkBlue,
                  ),
                ),
              const SizedBox(
                height: 12,
              ),
              if (!forShare)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: TransactionDialogAction.build(
                    settings.isTransactionDetails,
                    _share,
                    isSuccess: settings.isSuccess,
                    onVoid: settings.onVoid,
                    canCapture: settings.canCapture,
                    canRefund: settings.canRefund,
                    canVoid: settings.canVoid,
                    onRefund: settings.onRefund,
                    onCapture: settings.onCapture,
                    onClose: settings.onClose,
                    isRefunded: settings.isRefunded,
                    isCaptured: settings.isCaptured,
                    isSettled: settings.isSettled,
                    globalTranslator: settings.globalTranslator,
                    amount: settings.amount,
                    currency: settings.currency,
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
      child: dialog(forShare: _isSharing),
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
