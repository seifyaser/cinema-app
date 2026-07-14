import 'package:flutter/material.dart';
import 'package:paymob/paymob.dart';
import 'package:project/core/config/env_config.dart';

class PaymobService {
  /// Initiates a payment using the official Paymob SDK.
  /// You must provide the [clientSecret] obtained from your backend.
  static Future<PaymobPaymentResult> pay({
    required String clientSecret,
    String? appName,
    Color? buttonBackgroundColor,
    Color? buttonTextColor,
  }) async {
    final result = await Paymob.pay(
      publicKey: EnvConfig.paymobPublicKey,
      clientSecret: clientSecret,
      appName: appName ?? 'Cinema Immersive',
      buttonBackgroundColor: buttonBackgroundColor ?? Colors.deepPurple,
      buttonTextColor: buttonTextColor ?? Colors.white,
      showSaveCard: false,
    );

    return result;
  }
}
