import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/ui/loading_dialog.dart';
import 'package:flutter/material.dart';

mixin LoaderMixin {
  void showLoader(BuildContext context) {
    Navigator.of(context).push(
      DialogRoute(
        context: context,
        builder: (_)=> const LoadingDialog(),
      ),
    );
  }


  void dismissDialog(BuildContext context){
    Navigator.pop(context);
  }
}
