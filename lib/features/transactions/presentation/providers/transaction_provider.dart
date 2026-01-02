import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_detail.dart';
import '../../domain/usecases/get_all_transactions_usecase.dart';
import '../../domain/usecases/get_transaction_detail_usecase.dart';

enum TransactionStatus {
  initial,
  loading,
  loaded,
  error,
}

class TransactionProvider extends ChangeNotifier {
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
  
  // Pagination
  int _currentPage = 1;
  final int _limit = 20;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // Filters
  String? _selectedType;
  String? _selectedStatus;
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';

  // Getters
  TransactionStatus get status => _status;
  List<TransactionDetail> get transactions => _transactions;
  TransactionDetail? get selectedTransaction => _selectedTransaction;
  String? get errorMessage => _errorMessage;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  // Filter getters
  String? get selectedType => _selectedType;
  String? get selectedStatus => _selectedStatus;
  String? get selectedCategory => _selectedCategory;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // Filtered transactions
  List<TransactionDetail> get filteredTransactions {
    return _transactions.where((transaction) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final matchesSearch = (transaction.description?.toLowerCase().contains(searchLower) ?? false) ||
            (transaction.referenceNumber?.toLowerCase().contains(searchLower) ?? false) ||
            (transaction.recipientName?.toLowerCase().contains(searchLower) ?? false) ||
            (transaction.senderName?.toLowerCase().contains(searchLower) ?? false);
        if (!matchesSearch) return false;
      }

      // Type filter
      if (_selectedType != null && transaction.type != _selectedType) {
        return false;
      }

      // Status filter
      if (_selectedStatus != null && transaction.status != _selectedStatus) {
        return false;
      }

      // Category filter
      if (_selectedCategory != null && transaction.category != _selectedCategory) {
        return false;
      }

      return true;
    }).toList();
  }

  // Grouped transactions by date
  Map<String, List<TransactionDetail>> get groupedTransactions {
    final grouped = <String, List<TransactionDetail>>{};
    final dateFormat = DateFormat('MMMM dd, yyyy');

    for (var transaction in filteredTransactions) {
      final transactionDate = transaction.timestamp ?? transaction.createdAt;
      final dateKey = dateFormat.format(transactionDate);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    return grouped;
  }

  // Calculate total income
  double get totalIncome {
    return filteredTransactions
        .where((t) => t.isCredit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Calculate total expense
  double get totalExpense {
    return filteredTransactions
        .where((t) => t.isDebit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Load transactions (with optional refresh)
  Future<void> loadTransactions({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _transactions.clear();
    }

    _status = TransactionStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getAllTransactionsUseCase(
      page: _currentPage,
      limit: _limit,
      type: _selectedType,
      status: _selectedStatus,
      startDate: _startDate,
      endDate: _endDate,
    );

    result.fold(
      (failure) {
        _status = TransactionStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (transactions) {
        if (transactions.length < _limit) {
          _hasMore = false;
        }
        
        if (refresh) {
          _transactions = transactions;
        } else {
          _transactions.addAll(transactions);
        }
        
        _status = TransactionStatus.loaded;
        notifyListeners();
      },
    );
  }

  /// Load more transactions (pagination)
  Future<void> loadMoreTransactions() async {
    if (_isLoadingMore || !_hasMore || _status == TransactionStatus.loading) {
      return;
    }

    _isLoadingMore = true;
    _currentPage++;
    notifyListeners();

    final result = await getAllTransactionsUseCase(
      page: _currentPage,
      limit: _limit,
      type: _selectedType,
      status: _selectedStatus,
      startDate: _startDate,
      endDate: _endDate,
    );

    result.fold(
      (failure) {
        _currentPage--; // Revert page increment on error
        _isLoadingMore = false;
        notifyListeners();
      },
      (transactions) {
        if (transactions.length < _limit) {
          _hasMore = false;
        }
        _transactions.addAll(transactions);
        _isLoadingMore = false;
        notifyListeners();
      },
    );
  }

  /// Load single transaction detail
  Future<void> loadTransactionDetail(String transactionId) async {
    _status = TransactionStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await getTransactionDetailUseCase(transactionId);

    result.fold(
      (failure) {
        _status = TransactionStatus.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (transaction) {
        _selectedTransaction = transaction;
        _status = TransactionStatus.loaded;
        notifyListeners();
      },
    );
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Set type filter
  void setTypeFilter(String? type) {
    _selectedType = type;
    notifyListeners();
  }

  /// Set status filter
  void setStatusFilter(String? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  /// Set category filter
  void setCategoryFilter(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Set date range filter
  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedType = null;
    _selectedStatus = null;
    _selectedCategory = null;
    _startDate = null;
    _endDate = null;
    _searchQuery = '';
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all data
  void clearData() {
    _transactions = [];
    _selectedTransaction = null;
    _errorMessage = null;
    _status = TransactionStatus.initial;
    _currentPage = 1;
    _hasMore = true;
    clearFilters();
    notifyListeners();
  }
}