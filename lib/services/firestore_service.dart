import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Transactions
  Stream<List<TransactionModel>> getTransactions(String userId) {
    return _db
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('deleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<TransactionModel>> getTrashTransactions(String userId) {
    return _db
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('deleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addTransaction(TransactionModel transaction) {
    return _db.collection('transactions').add(transaction.toMap());
  }

  Future<void> updateTransaction(TransactionModel transaction) {
    return _db
        .collection('transactions')
        .doc(transaction.id)
        .update(transaction.toMap());
  }

  Future<void> deleteTransaction(String id) {
    return _db.collection('transactions').doc(id).update({
      'deleted': true,
      'deletedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> restoreTransaction(String id) {
    return _db.collection('transactions').doc(id).update({
      'deleted': false,
      'deletedAt': null,
    });
  }

  Future<void> deletePermanently(String id) {
    return _db.collection('transactions').doc(id).delete();
  }

  // Goals
  Stream<List<GoalModel>> getGoals(String userId) {
    return _db
        .collection('goals')
        .where('userId', isEqualTo: userId)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GoalModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addGoal(GoalModel goal) {
    return _db.collection('goals').add(goal.toMap());
  }

  Future<void> updateGoal(GoalModel goal) {
    return _db.collection('goals').doc(goal.id).update(goal.toMap());
  }

  Future<void> deleteGoal(String id) {
    return _db.collection('goals').doc(id).delete();
  }
}
