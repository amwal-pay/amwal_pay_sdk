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
                flex: 2,
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
              // const Spacer(),
              const SizedBox(width: 4),
              Expanded(
                flex: 3,
                child: (value.contains("-") && value.contains("OMR"))
                    ? buildMiunsValue(value)
                    : Row(
                        children: [
                          AutoSizeText(
                            value.trim(),
                            maxLines: 1,
                            style: valueStyle ??
                                const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: darkBlue,
                                ),
                          ),
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

  Widget buildMiunsValue(String value) {
    var valueCurrency = value.split(" ");
    // remove ay empty values
    valueCurrency.removeWhere((element) => element.isEmpty);
    return Row(children: [
     if(valueCurrency.first.isNotEmpty) Directionality(
        textDirection: TextDirection.ltr,
        child: AutoSizeText(
          valueCurrency.first,
          maxLines: 1,
          style: valueStyle ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: darkBlue,
              ),
        ),
      ),
      if(valueCurrency.first.isNotEmpty)   const SizedBox(width: 3),
      if(valueCurrency.last.isNotEmpty)   AutoSizeText(
        valueCurrency.last,
        maxLines: 1,
        style: valueStyle ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: darkBlue,
            ),
      ),
    ]);
  }
}
