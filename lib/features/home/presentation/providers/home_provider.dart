// lib/features/home/presentation/providers/home_provider.dart

import 'package:flutter/foundation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/get_account_balance_usecase.dart';
import '../../domain/usecases/get_recent_transactions_usecase.dart';

/// State enum for home screen
enum HomeState {
  initial,
  loading,
  loaded,
  refreshing,
  error,
}

/// Provider for managing home screen state
class HomeProvider extends ChangeNotifier {
  final GetAccountBalanceUseCase getAccountBalanceUseCase;
  final RefreshAccountUseCase refreshAccountUseCase;
  final GetAllAccountsUseCase getAllAccountsUseCase;
  final GetRecentTransactionsUseCase getRecentTransactionsUseCase;
  final Logger logger;

  HomeProvider({
    required this.getAccountBalanceUseCase,
    required this.refreshAccountUseCase,
    required this.getAllAccountsUseCase,
    required this.getRecentTransactionsUseCase,
    required this.logger,
  });

  // State variables
  HomeState _state = HomeState.initial;
  Account? _account;
  List<Account> _allAccounts = [];
  List<Transaction> _recentTransactions = [];
  String? _errorMessage;
  bool _isRefreshing = false;

  // Getters
  HomeState get state => _state;
  Account? get account => _account;
  List<Account> get allAccounts => _allAccounts;
  List<Transaction> get recentTransactions => _recentTransactions;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == HomeState.loading;
  bool get isRefreshing => _isRefreshing;
  bool get hasError => _state == HomeState.error;
  bool get hasData => _account != null;

  /// Initialize home screen data
  Future<void> initialize() async {
    if (_state == HomeState.loading) {
      logger.warning('Already loading, skipping initialize');
      return;
    }

    _setState(HomeState.loading);
    _errorMessage = null;

    try {
      logger.info('Initializing home screen');

      // Fetch account balance and recent transactions in parallel
      final results = await Future.wait([
        getAccountBalanceUseCase(NoParams()),
        getRecentTransactionsUseCase(const GetRecentTransactionsParams(limit: 10)),
      ]);

      // Process account balance result
      results[0].fold(
        (failure) {
          logger.error('Failed to fetch account: ${failure.message}');
          _errorMessage = failure.message;
          _setState(HomeState.error);
        },
        (account) {
          _account = account as Account;
          logger.info('Successfully fetched account: ${_account?.accountNumber}');
        },
      );

      // Process transactions result
      results[1].fold(
        (failure) {
          logger.error('Failed to fetch transactions: ${failure.message}');
          // Don't set error state if we have account data
          if (_account == null) {
            _errorMessage = failure.message;
            _setState(HomeState.error);
          }
        },
        (transactions) {
          _recentTransactions = transactions as List<Transaction>;
          logger.info('Successfully fetched ${_recentTransactions.length} transactions');
        },
      );

      // If we have account data, consider it loaded
      if (_account != null) {
        _setState(HomeState.loaded);
      }
    } catch (e) {
      logger.error('Unexpected error during initialization: $e');
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setState(HomeState.error);
    }
  }

  /// Refresh account data
  Future<void> refresh() async {
    if (_isRefreshing) {
      logger.warning('Already refreshing, skipping refresh');
      return;
    }

    _isRefreshing = true;
    notifyListeners();

    try {
      logger.info('Refreshing home screen data');

      // Refresh account and transactions in parallel
      final results = await Future.wait([
        refreshAccountUseCase(NoParams()),
        getRecentTransactionsUseCase(const GetRecentTransactionsParams(limit: 10)),
      ]);

      // Process account refresh result
      results[0].fold(
        (failure) {
          logger.error('Failed to refresh account: ${failure.message}');
          _errorMessage = failure.message;
        },
        (account) {
          _account = account as Account;
          logger.info('Successfully refreshed account: ${_account?.accountNumber}');
          _errorMessage = null;
        },
      );

      // Process transactions result
      results[1].fold(
        (failure) {
          logger.error('Failed to refresh transactions: ${failure.message}');
        },
        (transactions) {
          _recentTransactions = transactions as List<Transaction>;
          logger.info('Successfully refreshed ${_recentTransactions.length} transactions');
        },
      );

      if (_account != null) {
        _setState(HomeState.loaded);
      }
    } catch (e) {
      logger.error('Unexpected error during refresh: $e');
      _errorMessage = 'Failed to refresh data. Please try again.';
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Load all accounts
  Future<void> loadAllAccounts() async {
    try {
      logger.info('Loading all accounts');
      
      final result = await getAllAccountsUseCase(NoParams());
      
      result.fold(
        (failure) {
          logger.error('Failed to load all accounts: ${failure.message}');
        },
        (accounts) {
          _allAccounts = accounts;
          logger.info('Successfully loaded ${_allAccounts.length} accounts');
          notifyListeners();
        },
      );
    } catch (e) {
      logger.error('Unexpected error loading all accounts: $e');
    }
  }

  /// Switch to a different account
  void switchAccount(Account newAccount) {
    _account = newAccount;
    logger.info('Switched to account: ${newAccount.accountNumber}');
    notifyListeners();
    
    // Reload transactions for the new account
    _loadTransactionsForCurrentAccount();
  }

  /// Load transactions for current account
  Future<void> _loadTransactionsForCurrentAccount() async {
    try {
      logger.info('Loading transactions for current account');
      
      final result = await getRecentTransactionsUseCase(
        const GetRecentTransactionsParams(limit: 10),
      );
      
      result.fold(
        (failure) {
          logger.error('Failed to load transactions: ${failure.message}');
        },
        (transactions) {
          _recentTransactions = transactions;
          logger.info('Successfully loaded ${_recentTransactions.length} transactions');
          notifyListeners();
        },
      );
    } catch (e) {
      logger.error('Unexpected error loading transactions: $e');
    }
  }

  /// Retry loading data after error
  Future<void> retry() async {
    await initialize();
  }

  /// Set state and notify listeners
  void _setState(HomeState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    logger.info('HomeProvider disposed');
    super.dispose();
  }
}