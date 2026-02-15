class GoalModel {
  final String id;
  final String userId;
  final String description;
  final double target;
  final double current;
  final int order;

  GoalModel({
    required this.id,
    required this.userId,
    required this.description,
    required this.target,
    required this.current,
    required this.order,
  });

  factory GoalModel.fromMap(Map<String, dynamic> map, String id) {
    return GoalModel(
      id: id,
      userId: map['userId'] ?? '',
      description: map['description'] ?? '',
      target: (map['target'] ?? 0.0).toDouble(),
      current: (map['current'] ?? 0.0).toDouble(),
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'description': description,
      'target': target,
      'current': current,
      'order': order,
    };
  }
}
