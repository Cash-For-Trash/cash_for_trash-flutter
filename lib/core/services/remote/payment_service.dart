import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paymob_sdk/flutter_paymob_sdk.dart';

class PaymentService {
  final service = PaymobService();

  Future<String?> initPayment(String clientSecret) async {
    PaymobCustomization();

    final result = await service.payWithPaymob(
      publicKey: dotenv.env['PAYMOB_PUBLIC_KEY'] ?? '',
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
      "result.transactionDetails ${result.transactionDetails} and result.errorMessage ${result.errorMessage} and result.status ${result.status}",
    );

    if (result.isSuccessful) {
      return "Success";
    } else if (result.isFailure) {
      return result.errorMessage;
    } else if (result.isPending) {
      return null;
    }
    return null;
  }
}
