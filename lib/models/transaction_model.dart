
class Transaction {
  final String id;
  final String description;
  final double value;
  final String category;
  final String date; // YYYY-MM-DD
  final String type; // 'income' or 'expense'
  final bool favorite;
  final String userId;
  final bool deleted;

  Transaction({
    required this.id,
    required this.description,
    required this.value,
    required this.category,
    required this.date,
    required this.type,
    this.favorite = false,
    required this.userId,
    this.deleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'value': value,
      'category': category,
      'date': date,
      'type': type,
      'favorite': favorite,
      'userId': userId,
      'deleted': deleted,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map, String id) {
    return Transaction(
      id: id,
      description: map['description'] ?? '',
      value: (map['value'] ?? 0.0).toDouble(),
      category: map['category'] ?? 'Outros',
      date: map['date'] ?? '',
      type: map['type'] ?? 'expense',
      favorite: map['favorite'] ?? false,
      userId: map['userId'] ?? '',
      deleted: map['deleted'] ?? false,
    );
  }

  Transaction copyWith({
    String? id,
    String? description,
    double? value,
    String? category,
    String? date,
    String? type,
    bool? favorite,
    String? userId,
    bool? deleted,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      value: value ?? this.value,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      favorite: favorite ?? this.favorite,
      userId: userId ?? this.userId,
      deleted: deleted ?? this.deleted,
    );
  }
}
