import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';

class TransactionWidget extends StatelessWidget {
  final String title;
  final Widget image;
  final String date;
  final String amount;
  final TransactionStatus status;
  const TransactionWidget({
    Key? key,
    required this.title,
    required this.image,
    required this.date,
    required this.amount,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [image],
          ),
          minLeadingWidth: 24,
          title: Text(
            title,
            style: const TextStyle(
              color: darkBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            date,
            style: const TextStyle(
              color: greyColor,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (status == TransactionStatus.success)
                Text(
                  'successful'.translate(context),
                  style: const TextStyle(
                    color: successColor,
                  ),
                )
              else
                Text(
                  'failed'.translate(context),
                  style: const TextStyle(
                    color: failedColor,
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: const [
            SizedBox(
              width: 50,
            ),
            Expanded(
              child: Divider(
                height: 1,
                color: lightGreyColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum TransactionStatus {
  success,
  failed,
}
