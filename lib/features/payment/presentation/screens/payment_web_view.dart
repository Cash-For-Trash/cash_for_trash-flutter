import 'dart:developer';

import 'package:cash_for_trash/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String iFrameUrl;

  const PaymentWebView({super.key, required this.iFrameUrl});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _paymentHandled = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            log("PaymentWebView progress $progress");
          },
          onPageStarted: (String url) {
            log("PaymentWebView onPageStarted $url");
          },
          onPageFinished: (String url) {
            log("PaymentWebView onPageFinished $url");
          },
          onHttpError: (HttpResponseError error) {
            log("PaymentWebView onHttpError $error");
          },
          onWebResourceError: (WebResourceError error) {
            log("PaymentWebView onWebResourceError $error");
          },
          onNavigationRequest: (NavigationRequest request) {

            if (_paymentHandled) {
              return NavigationDecision.prevent;
            }

            if (request.url.contains('success')) {

              _paymentHandled = true;

              log("PaymentWebView onNavigationRequest URL ${request.url}");
              final bool isSuccess = request.url.contains('success=true');

              isSuccess
                  ? context.push(AppRoutes.homeScreen)
                  : Navigator.pop(context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.iFrameUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: _controller));
  }
}
