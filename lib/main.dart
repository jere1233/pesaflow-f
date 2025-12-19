// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  
  runApp(const PesaFlowApp());
}

class PesaFlowApp extends StatelessWidget {
  const PesaFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final apiClient = ApiClient();
    final storage = const FlutterSecureStorage();
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
        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authDataSource: authDataSource,
            storage: storage,
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
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'PesaFlow',
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