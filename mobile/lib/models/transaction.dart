class TransactionModel {
  final int id;
  final String invoiceNumber;
  final String customerName;
  final int totalCost;
  final String transactionStatus;
  final String assetName;

  final String? trackingNumber;
  final String? paymentStatus;
  final String? paymentMethod;

  final int? quantity;

  final String? startDate;
  final String? endDate;

  TransactionModel({
    required this.id,
    required this.invoiceNumber,
    required this.customerName,
    required this.totalCost,
    required this.transactionStatus,
    required this.assetName,
    this.trackingNumber,
    this.paymentStatus,
    this.paymentMethod,
    this.quantity,
    this.startDate,
    this.endDate,
  });

  factory TransactionModel.fromJson(
      Map<String, dynamic> json) {
    return TransactionModel(
      id: json["id"],
      invoiceNumber: json["invoiceNumber"],
      customerName: json["customerName"],
      totalCost: json["totalCost"],
      transactionStatus: json["transactionStatus"],

      assetName: json["asset"]?["name"] ?? "-",

      trackingNumber:
          json["shipment"]?["trackingNumber"],

      paymentStatus: json["paymentStatus"],

      paymentMethod: json["paymentMethod"],

      quantity: json["quantity"],

      startDate: json["startDate"],

      endDate: json["endDate"],
    );
  }
}