import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paymob_sdk/flutter_paymob_sdk.dart';

class PaymentService {
  final service = PaymobService();

  Future<String> initPayment(String clientSecret) async {
    try {
      final publicKey = dotenv.env['PAYMOB_PUBLIC_KEY'] ?? '';

      if (publicKey.isEmpty) {
        log("Paymob Error: PAYMOB_PUBLIC_KEY is missing in dotenv.");
        return "Payment configuration error: Public key missing.";
      }

      final result = await service.payWithPaymob(
        publicKey: publicKey,
        clientSecret: clientSecret,
        customization: PaymobCustomization(
          appName: 'Cash For Trash',
          buttonBackgroundColor: Colors.blue,
          buttonTextColor: Colors.white,
          showSaveCard: true,
          saveCardDefault: false,
        ),
      );

      log(
        "Paymob Result -> transactionDetails: ${result.transactionDetails}, "
            "errorMessage: ${result.errorMessage}, status: ${result.status}",
      );

      if (result.isSuccessful) {
        return "Success";
      } else if (result.isFailure) {
        return (result.errorMessage != null && result.errorMessage!.isNotEmpty)
            ? result.errorMessage!
            : "Payment failed. Please try again.";
      } else if (result.isPending) {
        return "Payment is pending verification.";
      } else {
        // User closed or backed out of the WebView
        return "Payment was cancelled.";
      }
    } catch (e, stackTrace) {
      log("Paymob initPayment Exception: $e", stackTrace: stackTrace);
      return "An unexpected error occurred during payment.";
    }
  }

}
