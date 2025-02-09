import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String snapToken;

  const PaymentWebView({Key? key, required this.snapToken}) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    print("Initializing WebView for snapToken: ${widget.snapToken}");

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          print("WebView loading started: $url");
        },
        onPageFinished: (url) {
          print("WebView loading finished: $url");
        },
        onWebResourceError: (error) {
          print("❌ WebView Error: $error");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Terjadi kesalahan saat membuka pembayaran")),
          );
        },
      ))
      ..loadRequest(
        Uri.parse("https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.snapToken}"),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran Midtrans")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
