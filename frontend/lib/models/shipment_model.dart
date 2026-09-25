class ShipmentModel {
  final String id;
  final String trackingId;
  final String sender;
  final String receiver;
  final String pickUp;
  final String deliveryTo;
  final double amount;
  final String currency;
  final String status;
  final String processingTime;
  final bool isPaid;

  const ShipmentModel({
    required this.id,
    required this.trackingId,
    required this.sender,
    required this.receiver,
    required this.pickUp,
    required this.deliveryTo,
    required this.amount,
    required this.currency,
    required this.status,
    required this.processingTime,
    required this.isPaid,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'];
    final double parsedAmount = (rawAmount is num) ? rawAmount.toDouble() : 0.0;

    return ShipmentModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      trackingId: json['trackingId'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      receiver: json['receiver'] as String? ?? '',
      pickUp: json['pickUp'] as String? ?? '',
      deliveryTo: json['deliveryTo'] as String? ?? '',
      amount: parsedAmount,
      currency: json['currency'] as String? ?? 'NGN',
      status: json['status'] as String? ?? 'In-Transit',
      processingTime: json['processingTime'] as String? ?? '',
      isPaid: json['isPaid'] as bool? ?? false,
    );
  }

  ShipmentModel copyWith({bool? isPaid}) {
    return ShipmentModel(
      id: id,
      trackingId: trackingId,
      sender: sender,
      receiver: receiver,
      pickUp: pickUp,
      deliveryTo: deliveryTo,
      amount: amount,
      currency: currency,
      status: status,
      processingTime: processingTime,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
