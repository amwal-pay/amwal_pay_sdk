import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPEntryDialog extends StatefulWidget {
  const OTPEntryDialog({super.key});

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
          const Text('Otp Verification'),
          const SizedBox(height: 32),
          Pinput(
            key: const Key('saleByCardPinPut'),
            controller: _pinPutController,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key: const Key('saleByCardOtbVerify'),
                  onPressed: () =>
                      Navigator.pop(context, _pinPutController.text),
                  child: const Text('Verify'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
