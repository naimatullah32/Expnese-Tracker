class ExpenseModel {
  final String? id;
  final String userId;
  final double amount;
  final String type; // income | expense
  final String category;
  final String description;
  final String paymentMethod;
  final DateTime createdAt;

  ExpenseModel({
    this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    required this.paymentMethod,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
