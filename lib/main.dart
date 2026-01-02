import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'core/theme/app_theme.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/utils/logger.dart';
import 'shared/routes/app_router.dart';
import 'features/authentication/data/datasources/auth_remote_datasource.dart';
import 'features/authentication/presentation/providers/auth_provider.dart';
import 'features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/presentation/providers/dashboard_provider.dart';
import 'features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'features/transactions/data/repositories/transaction_repository_impl.dart';
import 'features/transactions/domain/usecases/get_all_transactions_usecase.dart';
import 'features/transactions/domain/usecases/get_transaction_detail_usecase.dart';
import 'features/transactions/presentation/providers/transaction_provider.dart';
import 'features/accounts/data/services/account_service.dart'; 
import 'features/accounts/presentation/providers/account_provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const AutoNest());
}

class AutoNest extends StatelessWidget {
  const AutoNest({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final apiClient = ApiClient();
    final logger = Logger();
    final networkInfo = NetworkInfoImpl(Connectivity());
    
    // Initialize data sources
    final authDataSource = AuthRemoteDataSource(apiClient: apiClient);
    final dashboardDataSource = DashboardRemoteDataSourceImpl(
      dio: apiClient.dio,
      logger: logger,
    );

    return MultiProvider(
      providers: [
        // Auth Provider - FIXED: Added dio parameter
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authDataSource: authDataSource,
            dio: apiClient.dio, // 🔧 FIXED: Added required dio parameter
          )..checkAuthStatus(),
        ),
        
        // Dashboard Provider
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(
            repository: DashboardRepositoryImpl(
              remoteDataSource: dashboardDataSource,
              networkInfo: networkInfo,
              logger: logger,
            ),
          ),
        ),
        
        // Transactions Provider
        ChangeNotifierProvider(
          create: (_) {
            final transactionRemote = TransactionRemoteDataSourceImpl(dio: apiClient.dio);
            final transactionRepo = TransactionRepositoryImpl(remoteDataSource: transactionRemote);
            final getAll = GetAllTransactionsUseCase(transactionRepo);
            final getDetail = GetTransactionDetailUseCase(transactionRepo);
            return TransactionProvider(
              getAllTransactionsUseCase: getAll,
              getTransactionDetailUseCase: getDetail,
            );
          },
        ),
        
        // Account Provider
        ChangeNotifierProvider(
          create: (_) => AccountProvider(
            accountService: AccountService(),
          ),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'AutoNest',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}