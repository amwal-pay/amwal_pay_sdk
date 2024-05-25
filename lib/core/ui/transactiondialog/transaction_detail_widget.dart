import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TransactionDetailWidget extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  const TransactionDetailWidget({
    Key? key,
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  title.translate(context),
                  maxLines: 1,
                  style: titleStyle ??
                      const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: lightGreyColor,
                      ),
                ),
              ),
              Expanded(

                child: (!value.contains("-") || !value.contains("OMR") )
                    ? AutoSizeText(
                        value,
                        maxLines: 1,
                        style: valueStyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: darkBlue,
                            ),
                      )
                    : Row(
                      children: [
                        Directionality(
                            textDirection: TextDirection.ltr,
                            child: AutoSizeText(
                              value,
                              maxLines: 1,
                              style: valueStyle ??
                                  const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: darkBlue,
                                  ),
                            ),
                          ),
                        Spacer(),
                      ],
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
