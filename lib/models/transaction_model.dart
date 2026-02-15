import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String type; // 'income' or 'expense'
  final double value;
  final String category;
  final String description;
  final DateTime date;
  final bool isFavorite;
  final bool isDeleted;
  final DateTime? deletedAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.category,
    required this.description,
    required this.date,
    this.isFavorite = false,
    this.isDeleted = false,
    this.deletedAt,
  });

  // Factory for Firestore
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: data['type'] ?? 'expense',
      value: (data['value'] ?? 0.0).toDouble(),
      category: data['category'] ?? 'others',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      isFavorite: data['isFavorite'] ?? false,
      isDeleted: data['isDeleted'] ?? false,
      deletedAt: data['deletedAt'] != null 
          ? (data['deletedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  // To Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'value': value,
      'category': category,
      'description': description,
      'date': Timestamp.fromDate(date),
      'isFavorite': isFavorite,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
    };
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? type,
    double? value,
    String? category,
    String? description,
    DateTime? date,
    bool? isFavorite,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      value: value ?? this.value,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      isFavorite: isFavorite ?? this.isFavorite,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
