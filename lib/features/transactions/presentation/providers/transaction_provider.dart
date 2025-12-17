// lib/features/transactions/presentation/providers/transaction_provider.dart

import 'package:flutter/foundation.dart';
import '../../domain/entities/transaction_detail.dart';
import '../../domain/usecases/get_all_transactions_usecase.dart';
import '../../domain/usecases/get_transaction_detail_usecase.dart';

enum TransactionStatus { initial, loading, loaded, error }

class TransactionProvider with ChangeNotifier {
  final GetAllTransactionsUseCase getAllTransactionsUseCase;
  final GetTransactionDetailUseCase getTransactionDetailUseCase;

  TransactionProvider({
    required this.getAllTransactionsUseCase,
    required this.getTransactionDetailUseCase,
  });

  // State
  TransactionStatus _status = TransactionStatus.initial;
  List<TransactionDetail> _transactions = [];
  TransactionDetail? _selectedTransaction;
  String? _errorMessage;

  // Filters
  String? _selectedType;
  String? _selectedStatus;
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';

  // Pagination
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  // Getters
  TransactionStatus get status => _status;
  List<TransactionDetail> get transactions => _transactions;
  TransactionDetail? get selectedTransaction => _selectedTransaction;
  String? get errorMessage => _errorMessage;
  String? get selectedType => _selectedType;
  String? get selectedStatus => _selectedStatus;
  String? get selectedCategory => _selectedCategory;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get searchQuery => _searchQuery;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;

  // Filtered transactions (client-side filtering for better UX)
  List<TransactionDetail> get filteredTransactions {
    var filtered = _transactions;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        final query = _searchQuery.toLowerCase();
        return transaction.description.toLowerCase().contains(query) ||
            transaction.recipientName?.toLowerCase().contains(query) == true ||
            transaction.referenceNumber?.toLowerCase().contains(query) == true;
      }).toList();
    }

    return filtered;
  }

  // Get grouped transactions by date
  Map<String, List<TransactionDetail>> get groupedTransactions {
    final Map<String, List<TransactionDetail>> grouped = {};

    for (var transaction in filteredTransactions) {
      final date = _formatDate(transaction.timestamp);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }

    return grouped;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Load transactions
  Future<void> loadTransactions({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMoreData = true;
      _transactions.clear();
    }

    _status = TransactionStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getAllTransactionsUseCase(
      page: _currentPage,
      limit: 20,
      type: _selectedType,
      status: _selectedStatus,
      startDate: _startDate,
      endDate: _endDate,
    );

    result.fold(
      (failure) {
        _status = TransactionStatus.error;
        _errorMessage = failure.message;
      },
      (transactions) {
        if (refresh) {
          _transactions = transactions;
        } else {
          _transactions.addAll(transactions);
        }
        _hasMoreData = transactions.length >= 20;
        _status = TransactionStatus.loaded;
      },
    );

    notifyListeners();
  }

  // Load more transactions (pagination)
  Future<void> loadMoreTransactions() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    final result = await getAllTransactionsUseCase(
      page: _currentPage,
      limit: 20,
      type: _selectedType,
      status: _selectedStatus,
      startDate: _startDate,
      endDate: _endDate,
    );

    result.fold(
      (failure) {
        _currentPage--; // Revert page increment on error
        _errorMessage = failure.message;
      },
      (transactions) {
        _transactions.addAll(transactions);
        _hasMoreData = transactions.length >= 20;
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  // Load transaction detail
  Future<void> loadTransactionDetail(String transactionId) async {
    _status = TransactionStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getTransactionDetailUseCase(transactionId);

    result.fold(
      (failure) {
        _status = TransactionStatus.error;
        _errorMessage = failure.message;
      },
      (transaction) {
        _selectedTransaction = transaction;
        _status = TransactionStatus.loaded;
      },
    );

    notifyListeners();
  }

  // Set filters
  void setTypeFilter(String? type) {
    _selectedType = type;
    loadTransactions(refresh: true);
  }

  void setStatusFilter(String? status) {
    _selectedStatus = status;
    loadTransactions(refresh: true);
  }

  void setCategoryFilter(String? category) {
    _selectedCategory = category;
    loadTransactions(refresh: true);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    loadTransactions(refresh: true);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearFilters() {
    _selectedType = null;
    _selectedStatus = null;
    _selectedCategory = null;
    _startDate = null;
    _endDate = null;
    _searchQuery = '';
    loadTransactions(refresh: true);
  }

  // Clear selected transaction
  void clearSelectedTransaction() {
    _selectedTransaction = null;
    notifyListeners();
  }

  // Statistics
  double get totalIncome {
    return _transactions
        .where((t) => t.isCredit && t.isCompleted)
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions
        .where((t) => t.isDebit && t.isCompleted)
        .fold(0, (sum, t) => sum + t.amount);
  }

  int get transactionCount => _transactions.length;
}