import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  List<GoalModel> _goals = [];
  User? _user;
  bool _isLoading = false;
  
  // Filters
  String _filterDescription = '';
  String? _filterCategory;
  String? _filterType;
  int? _filterYear;
  bool _filterFavorites = false;
  List<int> _filterMonths = [];

  List<TransactionModel> get transactions => _filterTransactions();
  List<GoalModel> get goals => _goals;
  bool get isLoading => _isLoading;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void updateUser(User? user) {
    _user = user;
    if (_user != null) {
      _fetchData();
      _fetchGoals();
    } else {
      _transactions = [];
      _goals = [];
      notifyListeners();
    }
  }

  void _fetchData() {
    if (_user == null) return;
    _isLoading = true;
    _db
        .collection('transactions')
        .where('userId', isEqualTo: _user!.uid)
        .where('deleted', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      _transactions = snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
          .toList();
      // Sort by date descending
      _transactions.sort((a, b) => b.date.compareTo(a.date));
      _isLoading = false;
      notifyListeners();
    });
  }

   void _fetchGoals() {
    if (_user == null) return;
    _db
        .collection('goals')
        .where('userId', isEqualTo: _user!.uid)
        .snapshots()
        .listen((snapshot) {
      _goals = snapshot.docs
          .map((doc) => GoalModel.fromMap(doc.data(), doc.id))
          .toList();
      _goals.sort((a, b) => a.order.compareTo(b.order));
      notifyListeners();
    });
  }

  // Filtering Logic
  void setFilters({
    String? description,
    String? category,
    String? type,
    int? year,
    bool? favorites,
    List<int>? months,
  }) {
    if (description != null) _filterDescription = description;
    _filterCategory = category; // Allow null to clear
    _filterType = type; // Allow null to clear
    _filterYear = year; // Allow null to clear
    if (favorites != null) _filterFavorites = favorites;
    if (months != null) _filterMonths = months;
    
    notifyListeners();
  }

  void clearFilters() {
    _filterDescription = '';
    _filterCategory = null;
    _filterType = null;
    _filterYear = null;
    _filterFavorites = false;
    _filterMonths = [];
    notifyListeners();
  }

  List<TransactionModel> _filterTransactions() {
    return _transactions.where((tx) {
      if (_filterDescription.isNotEmpty &&
          !tx.description.toLowerCase().contains(_filterDescription.toLowerCase())) {
        return false;
      }
      if (_filterCategory != null && tx.category != _filterCategory) return false;
      if (_filterType != null && tx.type != _filterType) return false;
      if (_filterFavorites && !tx.favorite) return false;

      DateTime date = DateTime.parse(tx.date);
      if (_filterYear != null && date.year != _filterYear) return false;
      if (_filterMonths.isNotEmpty && !_filterMonths.contains(date.month)) return false;

      return true;
    }).toList();
  }
  
  // CRUD Wrappers if needed, or stick to Service. 
  // Ideally Provider calls Service. For simplicity here using direct Firestore or Service in UI.
  // But let's add basic add here for cleaner UI code.

  Future<void> addTransaction(TransactionModel tx) async {
    if (_user == null) return;
    await _db.collection('transactions').add(tx.toMap());
  }
  
  Future<void> updateTransaction(TransactionModel tx) async {
    if (_user == null) return;
    await _db.collection('transactions').doc(tx.id).update(tx.toMap());
  }

  Future<void> deleteTransaction(String id) async {
     await _db.collection('transactions').doc(id).update({
      'deleted': true,
      'deletedAt': DateTime.now().toIso8601String(),
    });
  }
  
  Future<void> toggleFavorite(String id, bool currentStatus) async {
      await _db.collection('transactions').doc(id).update({
      'favorite': !currentStatus,
    });
  }

  // Calculations
  double get totalIncome => transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + t.value);

  double get totalExpense => transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, t) => sum + t.value);

  double get balance => totalIncome - totalExpense;
}
