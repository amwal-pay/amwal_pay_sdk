import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      height: 10,
      child: Lottie.asset(
        'assets/json/lottiefiles/app_loader.json',
      ),
    );
  }
}
