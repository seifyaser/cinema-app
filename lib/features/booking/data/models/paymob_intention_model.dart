class PaymobIntentionModel {
  final String clientSecret;
  final String? id;
  final String? status;
  final String? intentionOrderId;
  final String? paymentKey;

  PaymobIntentionModel({
    required this.clientSecret,
    this.id,
    this.status,
    this.intentionOrderId,
    this.paymentKey,
  });

  factory PaymobIntentionModel.fromJson(Map<String, dynamic> json) {
    String? pKey;
    if (json['payment_keys'] != null && (json['payment_keys'] as List).isNotEmpty) {
      pKey = json['payment_keys'][0]['key'] as String?;
    }

    return PaymobIntentionModel(
      // Handles both "client_secret" (raw Paymob) and "clientSecret" (your backend wrapper)
      clientSecret: json['client_secret'] as String? ?? json['clientSecret'] as String? ?? '',
      id: json['id'] as String?,
      status: json['status'] as String?,
      intentionOrderId: json['intention_order_id']?.toString(),
      paymentKey: pKey,
    );
  }
}
