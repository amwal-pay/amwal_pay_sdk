import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/resources/color/colors.dart';

class ThreeDSWebViewPage extends StatefulWidget {
  final String url;
  final void Function(String transactionId) onTransactionIdFound;

  const ThreeDSWebViewPage({
    required this.url,
    required this.onTransactionIdFound,
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
            final Uri uri = Uri.parse(url);
            if (uri.queryParameters.containsKey('transactionId')) {
              final transactionId = uri.queryParameters['transactionId']!;
              Navigator.of(context).pop();
              widget.onTransactionIdFound(transactionId);
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
        backgroundColor: whiteColor,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}