import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/alert_dialog/alert_dialog.dart';
import 'package:amwal_pay_sdk/core/ui/buttons/app_button.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

typedef OnCloseCallback = void Function()?;

abstract class TransactionDialogAction extends StatelessWidget {
  const TransactionDialogAction({super.key});

  factory TransactionDialogAction.build(
    bool isTransactionDetails,
      void Function() share,
      {
    OnCloseCallback onClose,
    bool? isSettled,
    bool? isCaptured,
    bool? isRefunded,
    bool? isCredit,
    String Function(String)? globalTranslator,
  }) {
    if (isTransactionDetails) {
      return TransactionDialogActionButtonsForTransaction(
        onClose: onClose,
        isRefunded: isRefunded,
        isCaptured: isCaptured,
        isCredit: isCredit,
        isSettled: isSettled,
        globalTranslator: globalTranslator,
        share: share,
      );
    } else {
      return TransactionDialogActionButtons(
        onClose: onClose,
        globalTranslator: globalTranslator,
        share: share,
      );
    }
  }
}

class TransactionDialogActionButtons extends TransactionDialogAction {
  final void Function()? onClose;
  final String Function(String)? globalTranslator;
  final void Function() share;
  const TransactionDialogActionButtons({
    Key? key,
    required this.share,
    this.onClose,
    this.globalTranslator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: greyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: share,
                    child: Text(
                      'share_btn'.translate(
                        context,
                        globalTranslator: globalTranslator,
                      ),
                      style: const TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: AppButton(
                onPressed: onClose ?? Navigator.of(context).pop,
                child: Text(
                  'close'.translate(
                    context,
                    globalTranslator: globalTranslator,
                  ),
                  style: const TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class TransactionDialogActionButtonsForTransaction
    extends TransactionDialogAction {
  final void Function()? onClose;
  final bool? isSettled;
  final bool? isCaptured;
  final bool? isRefunded;
  final bool? isCredit;
  final String Function(String)? globalTranslator;
  final void Function() share;

  const TransactionDialogActionButtonsForTransaction({
    Key? key,
    this.onClose,
    this.isSettled,
    this.isCaptured,
    this.isRefunded,
    this.isCredit,
    this.globalTranslator,
    required this.share,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (isRefunded == false)
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: FittedBox(
                      child: Text(
                        'refund'.translate(
                          context,
                          globalTranslator: globalTranslator,
                        ),
                        style: const TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 8),
            if (isCaptured == false)
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greyColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AppAlertDialog(
                            title: 'capture',
                            content: 'capture_hint_txt',
                            actionButtonText: 'confirm',
                            actionButtonColor: primaryColor,
                            globalTranslator: globalTranslator,
                            actionButtonFn: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      },
                      child: FittedBox(
                        child: Text(
                          'capture'.translate(
                            context,
                            globalTranslator: globalTranslator,
                          ),
                          style: const TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      )),
                ),
              ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 55,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: share,
                    child: Text(
                      'share_btn'.translate(
                        context,
                        globalTranslator: globalTranslator,
                      ),
                      style: const TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppButton(
          onPressed: onClose ?? Navigator.of(context).pop,
          child: Text(
            'close'.translate(
              context,
              globalTranslator: globalTranslator,
            ),
            style: const TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
