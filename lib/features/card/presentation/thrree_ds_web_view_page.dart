import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/resources/color/colors.dart';

class ThreeDSWebViewPage extends StatefulWidget {
  final String url;
  final void Function(String transactionId) onTransactionIdFound;
  final void Function(PurchaseData) onTransactionFound;

  const ThreeDSWebViewPage({
    required this.url,
    required this.onTransactionIdFound,
    required this.onTransactionFound,
    Key? key,
  }) : super(key: key);

  @override
  _ThreeDSWebViewPageState createState() => _ThreeDSWebViewPageState();
}

class _ThreeDSWebViewPageState extends State<ThreeDSWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            final Uri? uri = Uri.tryParse(url);
            if (uri!= null && uri.queryParameters.containsKey('transactionId')) {
                debugPrint(url);
              final purchaseData = PurchaseData.fromUri(uri);
              Navigator.of(context).pop();
              // widget.onTransactionIdFound(transactionId);
              widget.onTransactionFound(purchaseData);
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('Error: $error');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: lightGeryColor,
      appBar: AppBar(
        title: const Text('3DS Authentication'),
        backgroundColor: primaryColor,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
