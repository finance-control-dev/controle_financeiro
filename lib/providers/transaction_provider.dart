import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/transaction_model.dart';
import '../models/goal_model.dart';
import 'dart:async';

class TransactionProvider with ChangeNotifier {
  FirestoreService? _firestoreService;
  StreamSubscription? _transactionSubscription;
  StreamSubscription? _goalsSubscription;

  List<TransactionModel> _transactions = [];
  List<GoalModel> _goals = [];
  bool _isLoading = false;

  // Filters
  String _filterDescription = '';
  String? _filterType; // 'income' or 'expense'

  // Getters
  List<TransactionModel> get transactions => _applyFilters(_transactions);
  List<GoalModel> get goals => _goals;
  bool get isLoading => _isLoading;

  void updateAuth(User? user) {
    if (user != null) {
      _firestoreService = FirestoreService(userId: user.uid);
      _initStreams();
    } else {
      _firestoreService = null;
      _transactions = [];
      _goals = [];
      _cancelStreams();
      notifyListeners();
    }
  }

  void _initStreams() {
    _isLoading = true;
    notifyListeners();

    _cancelStreams(); // Ensure no duplicates

    if (_firestoreService != null) {
      _transactionSubscription = _firestoreService!.getTransactionsStream().listen((data) {
        _transactions = data;
        _isLoading = false;
        notifyListeners();
      });

      _goalsSubscription = _firestoreService!.getGoalsStream().listen((data) {
        _goals = data;
        notifyListeners();
      });
    }
  }

  void _cancelStreams() {
    _transactionSubscription?.cancel();
    _goalsSubscription?.cancel();
  }

  @override
  void dispose() {
    _cancelStreams();
    super.dispose();
  }

  // Business Logic: Filters
  void setFilters({String? description, String? type}) {
    if (description != null) _filterDescription = description;
    _filterType = type; // Can be null to clear
    notifyListeners();
  }
  
  void clearFilters() {
    _filterDescription = '';
    _filterType = null;
    notifyListeners();
  }

  List<TransactionModel> _applyFilters(List<TransactionModel> list) {
    return list.where((tx) {
      if (_filterDescription.isNotEmpty &&
          !tx.description.toLowerCase().contains(_filterDescription.toLowerCase())) {
        return false;
      }
      if (_filterType != null && tx.type != _filterType) {
        return false;
      }
      return true;
    }).toList();
  }

  // Business Logic: Calculations
  double get totalIncome => _transactions
      .where((t) => t.type == 'income' && !t.isDeleted)
      .fold(0.0, (sum, t) => sum + t.value);

  double get totalExpense => _transactions
      .where((t) => t.type == 'expense' && !t.isDeleted)
      .fold(0.0, (sum, t) => sum + t.value);

  double get balance => totalIncome - totalExpense;

  // Actions
  Future<void> addTransaction(TransactionModel tx) async {
    await _firestoreService?.addTransaction(tx);
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    await _firestoreService?.updateTransaction(tx);
  }

  Future<void> deleteTransaction(String id) async {
    await _firestoreService?.deleteTransactionSoft(id);
  }

  Future<void> addGoal(GoalModel goal) async {
    await _firestoreService?.addGoal(goal);
  }
  
  Future<void> updateGoal(GoalModel goal) async {
    await _firestoreService?.updateGoal(goal);
  }
}
