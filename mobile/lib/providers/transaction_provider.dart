import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/history_service.dart';
import '../services/transaction_service.dart';

enum TransactionState {
  idle,
  loading,
  loaded,
  error,
}

class TransactionProvider extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  final HistoryService _historyService = HistoryService();

  TransactionState _state = TransactionState.idle;
  List<TransactionModel> _transactions = [];
  String? _errorMessage;

  TransactionState get state => _state;
  List<TransactionModel> get transactions => _transactions;
  String? get errorMessage => _errorMessage;

  List<TransactionModel> get ongoingTransactions =>
      _transactions.where((t) => t.transactionStatus == "ONGOING").toList();

  List<TransactionModel> get completedTransactions =>
      _transactions.where((t) => t.transactionStatus == "COMPLETED").toList();

  void setToken(String token) {
    _transactionService.setToken(token);
    _historyService.setToken(token);
  }

  /// Fetch all transactions
  Future<void> fetchTransactions() async {
    _state = TransactionState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _historyService.getHistory();
      _state = TransactionState.loaded;
    } catch (e) {
      _state = TransactionState.error;
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    }

    notifyListeners();
  }

  /// Create a new transaction
  Future<int?> createTransaction({
    required int assetId,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required int quantity,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _errorMessage = null;

    try {
      final id = await _transactionService.createTransaction(
        assetId: assetId,
        customerName: customerName,
        customerPhone: customerPhone,
        customerAddress: customerAddress,
        quantity: quantity,
        startDate: startDate,
        endDate: endDate,
      );

      await fetchTransactions();
      return id;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return null;
    }
  }

  /// Process return
  Future<bool> processReturn(int transactionId) async {
    _errorMessage = null;

    try {
      await _transactionService.returnTransaction(transactionId);
      await fetchTransactions();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return false;
    }
  }

  /// Process payment
  Future<bool> processPayment({
    required int transactionId,
    required String paymentMethod,
  }) async {
    _errorMessage = null;

    try {
      await _transactionService.payTransaction(
        id: transactionId,
        paymentMethod: paymentMethod,
      );
      await fetchTransactions();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return false;
    }
  }
}
