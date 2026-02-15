import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  FirestoreService({required this.userId});

  // --- Transactions ---

  Stream<List<TransactionModel>> getTransactionsStream() {
    return _db
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromFirestore(doc))
            .toList());
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _db.collection('transactions').add(transaction.toMap());
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _db
        .collection('transactions')
        .doc(transaction.id)
        .update(transaction.toMap());
  }

  Future<void> deleteTransactionSoft(String id) async {
    await _db.collection('transactions').doc(id).update({
      'isDeleted': true,
      'deletedAt': Timestamp.now(),
    });
  }

  // --- Goals ---

  Stream<List<GoalModel>> getGoalsStream() {
    return _db
        .collection('goals')
        .where('userId', isEqualTo: userId)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GoalModel.fromFirestore(doc))
            .toList());
  }

  Future<void> addGoal(GoalModel goal) async {
    await _db.collection('goals').add(goal.toMap());
  }

  Future<void> updateGoal(GoalModel goal) async {
    await _db.collection('goals').doc(goal.id).update(goal.toMap());
  }
}
