import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPEntryDialog extends StatefulWidget {
  final String verifyString;
  final String otpVerificationString;
  final void Function(String, BuildContext) onSubmit;

  const OTPEntryDialog({
    super.key,
    required this.verifyString,
    required this.otpVerificationString,
    required this.onSubmit,
  });

  @override
  State<OTPEntryDialog> createState() => _FourBoxOTPEntryDialogState();
}

class _FourBoxOTPEntryDialogState extends State<OTPEntryDialog> {
  late TextEditingController _pinPutController;

  @override
  void initState() {
    super.initState();
    _pinPutController = TextEditingController();
  }

  @override
  void dispose() {
    _pinPutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: const Key('saleByCardOtpDialog'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.otpVerificationString,
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.clear),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              key: const Key('saleByCardPinPut'),
              controller: _pinPutController,
              autofocus: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key: const Key('saleByCardOtbVerify'),
                  onPressed: () {
                    widget.onSubmit(_pinPutController.text, context);
                    _pinPutController.clear();
                  },
                  child: Text(widget.verifyString),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
