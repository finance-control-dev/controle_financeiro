import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String id;
  final String userId;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final int order;

  GoalModel({
    required this.id,
    required this.userId,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.order,
  });

  factory GoalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GoalModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      description: data['description'] ?? '',
      targetAmount: (data['targetAmount'] ?? 0.0).toDouble(),
      currentAmount: (data['currentAmount'] ?? 0.0).toDouble(),
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'order': order,
    };
  }
}
