class TransactionModel {
  final String id;
  final String userId;
  final String type; // 'income' or 'expense'
  final double value;
  final String category;
  final String description;
  final String date; // YYYY-MM-DD
  final String time;
  final bool favorite;
  final bool deleted;
  final String? deletedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    this.favorite = false,
    this.deleted = false,
    this.deletedAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      userId: map['userId'] ?? '',
      type: map['type'] ?? 'expense',
      value: (map['value'] ?? 0.0).toDouble(),
      category: map['category'] ?? 'outros',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      favorite: map['favorite'] ?? false,
      deleted: map['deleted'] ?? false,
      deletedAt: map['deletedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'value': value,
      'category': category,
      'description': description,
      'date': date,
      'time': time,
      'favorite': favorite,
      'deleted': deleted,
      'deletedAt': deletedAt,
    };
  }
}
