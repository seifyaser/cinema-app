import 'package:flutter/material.dart';
import 'package:flutter_paymob_sdk/flutter_paymob_sdk.dart' as paymob_sdk;

class PaymobService {
  final _sdkService = paymob_sdk.PaymobService();

  /// Initiates a payment using the official Paymob Flutter SDK.
  /// [clientSecret] is obtained from your backend /payments/intention endpoint.
  Future<paymob_sdk.PaymobPaymentResult> pay({
    required String clientSecret,
    String appName = 'Cinema Immersive',
    Color buttonBackgroundColor = Colors.deepPurple,
    Color buttonTextColor = Colors.white,
  }) async {
    final result = await _sdkService.payWithPaymob(
      publicKey: 'egy_pk_test_fO4LnfA1Q767OMJlnTSz5gAJ0ChavYVg',
      clientSecret: clientSecret,

      customization: paymob_sdk.PaymobCustomization(
        appName: appName,
        buttonBackgroundColor: buttonBackgroundColor,
        buttonTextColor: buttonTextColor,
        showSaveCard: true,
        saveCardDefault: true,
        showTransactionResult: true,
      ),
    );
    debugPrint('''
=========================
Paymob Result
status: ${result.status}
success: ${result.isSuccessful}
error: ${result.errorMessage}
details: ${result.transactionDetails}
debugPrint('isSuccessful: ${result.isSuccessful}');
=========================
''');

    return result;
  }
}
