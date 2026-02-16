import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/transaction_model.dart';
import 'package:uuid/uuid.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  FirebaseFirestore? _firestore;
  String _userId = 'test_user'; // Should come from AuthProvider

  List<Transaction> get transactions => _transactions.where((t) => !t.deleted).toList();
  bool get isLoading => _isLoading;

  // Totals
  double get totalIncome => transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + t.value);

  double get totalExpense => transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, t) => sum + t.value);

  double get balance => totalIncome - totalExpense;

  TransactionProvider() {
    _initFirestore();
  }

  Future<void> _initFirestore() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _firestore = FirebaseFirestore.instance;
        _loadTransactions();
      } else {
        // Fallback to mock data if Firebase not inited
        print("Firebase not initialized in Provider");
        _loadMockData();
      }
    } catch (e) {
      print("Error initializing Firestore: $e");
      _loadMockData();
    }
  }

  void _loadMockData() {
    _transactions = [
      Transaction(
        id: const Uuid().v4(),
        description: 'Salário (Mock)',
        value: 5000.0,
        category: 'Salário',
        date: DateTime.now().toString().split(' ')[0],
        type: 'income',
        userId: _userId,
      ),
      Transaction(
        id: const Uuid().v4(),
        description: 'Aluguel (Mock)',
        value: 1500.0,
        category: 'Moradia',
        date: DateTime.now().toString().split(' ')[0],
        type: 'expense',
        userId: _userId,
      ),
    ];
    notifyListeners();
  }

  Future<void> _loadTransactions() async {
    if (_firestore == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore!
          .collection('transactions')
          .where('userId', isEqualTo: _userId)
          .where('deleted', isEqualTo: false)
          .get();

      _transactions = snapshot.docs.map((doc) {
        return Transaction.fromMap(doc.data(), doc.id);
      }).toList();
      
      // Sort by date desc
      _transactions.sort((a, b) => b.date.compareTo(a.date));
      
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    // Optimistic update
    _transactions.insert(0, transaction);
    notifyListeners();

    if (_firestore != null) {
      try {
        await _firestore!.collection('transactions').doc(transaction.id).set(transaction.toMap());
      } catch (e) {
        print("Error adding transaction to Firestore: $e");
        // Rollback? or just let it stay locally
      }
    }
  }

  Future<void> deleteTransaction(String id) async {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      // Optimistic update
      _transactions[index] = _transactions[index].copyWith(deleted: true);
      notifyListeners();

      if (_firestore != null) {
        try {
          await _firestore!.collection('transactions').doc(id).update({'deleted': true});
        } catch (e) {
          print("Error deleting transaction in Firestore: $e");
        }
      }
    }
  }

  Future<void> toggleFavorite(String id) async {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      final t = _transactions[index];
      final newValue = !t.favorite;
      
      _transactions[index] = t.copyWith(favorite: newValue);
      notifyListeners();

      if (_firestore != null) {
        try {
          await _firestore!.collection('transactions').doc(id).update({'favorite': newValue});
        } catch (e) {
          print("Error updating favorite in Firestore: $e");
        }
      }
    }
  }
}
