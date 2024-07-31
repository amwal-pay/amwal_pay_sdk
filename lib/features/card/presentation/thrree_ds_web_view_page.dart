import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ThreeDSWebViewPage extends StatelessWidget {
  final String url;
  final void Function(String transactionId) onTransactionIdFound;

  const ThreeDSWebViewPage({
    required this.url,
    required this.onTransactionIdFound,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3DS Authentication')),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (String url) {
          // Check if the URL contains the transaction ID
          final Uri uri = Uri.parse(url);
          if (uri.queryParameters.containsKey('transactionId')) {
            final transactionId = uri.queryParameters['transactionId']!;
            onTransactionIdFound(transactionId);
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}