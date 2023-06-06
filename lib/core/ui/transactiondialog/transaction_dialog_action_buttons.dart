import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/alert_dialog/alert_dialog.dart';
import 'package:amwal_pay_sdk/core/ui/buttons/app_button.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

typedef NullableVoidCallback = void Function()?;

abstract class TransactionDialogAction extends StatelessWidget {
  const TransactionDialogAction({super.key});

  factory TransactionDialogAction.build(
    bool isTransactionDetails,
    void Function() share, {
    bool isSuccess = false,
    bool canRefund = false,
    bool canVoid = false,
    bool canCapture = false,
    NullableVoidCallback onRefund,
    NullableVoidCallback onCapture,
    NullableVoidCallback onVoid,
    NullableVoidCallback onClose,
    bool? isSettled,
    bool? isCaptured,
    bool? isRefunded,
    bool? isCredit,
    String Function(String)? globalTranslator,
  }) {
    if (isTransactionDetails && isSuccess) {
      return TransactionDialogActionButtonsForTransaction(
        globalTranslator: globalTranslator,
        isRefunded: isRefunded,
        isCaptured: isCaptured,
        canCapture: canCapture,
        onCapture: onCapture,
        isSettled: isSettled,
        canRefund: canRefund,
        onRefund: onRefund,
        isCredit: isCredit,
        canVoid: canVoid,
        onClose: onClose,
        onVoid: onVoid,
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
  final NullableVoidCallback onClose;
  final NullableVoidCallback onRefund;
  final NullableVoidCallback onCapture;
  final NullableVoidCallback onVoid;
  final bool? isSettled;
  final bool? isCaptured;
  final bool? isRefunded;
  final bool? isCredit;
  final bool canRefund;
  final bool canVoid;
  final bool canCapture;
  final String Function(String)? globalTranslator;
  final void Function() share;

  const TransactionDialogActionButtonsForTransaction({
    Key? key,
    this.canRefund = false,
    this.canVoid = false,
    this.canCapture = false,
    this.onVoid,
    this.onClose,
    this.onRefund,
    this.onCapture,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (canRefund)
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
                    onPressed: onRefund,
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
            if (canRefund) const SizedBox(width: 8),
            if (canCapture)
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
                              onCapture?.call();
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
            if (canCapture) const SizedBox(width: 8),
            if (canVoid)
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
                    onPressed: onVoid,
                    child: FittedBox(
                      child: Text(
                        'void'.translate(
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
            if (canVoid) const SizedBox(width: 8),
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
