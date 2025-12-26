// lib/shared/routes/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/otp_verification_screen.dart';
import '../../features/authentication/presentation/screens/login_otp_verification_screen.dart';
import '../../features/authentication/presentation/screens/payment_status_screen.dart';
import '../../features/authentication/presentation/screens/terms_and_conditions_screen.dart'; // 🆕 NEW
import '../../features/dashboard/presentation/screens/dashboard_screen.dart'; 
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../../features/transactions/presentation/screens/transaction_detail_screen.dart';
import '../../features/transfer/presentation/screens/transfer_screen.dart';
import '../../features/payments/presentation/screens/payments_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import 'route_names.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.login,
    routes: [
      // Authentication Routes
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      
      // ============================================================================
      // 🆕 NEW: Terms and Conditions Screen
      // ============================================================================
      GoRoute(
        path: RouteNames.termsAndConditions,
        name: RouteNames.termsAndConditions,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return TermsAndConditionsScreen(
            htmlContent: extra?['htmlContent'],
            showAcceptButton: extra?['showAcceptButton'] ?? false,
            onAccept: extra?['onAccept'],
          );
        },
      ),
      
      // ============================================================================
      // 🆕 NEW: Login OTP Verification (with optional password setting)
      // ============================================================================
      GoRoute(
        path: RouteNames.loginOtpVerification,
        name: RouteNames.loginOtpVerification,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return LoginOtpVerificationScreen(
            identifier: extra?['identifier'] ?? '',
            verificationType: extra?['verificationType'] ?? 'login',
          );
        },
      ),
      
      // ============================================================================
      // 🔧 EXISTING: OTP Verification (for registration, forgot password, etc.)
      // ============================================================================
      GoRoute(
        path: RouteNames.otpVerification,
        name: RouteNames.otpVerification,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpVerificationScreen(
            identifier: extra?['identifier'] ?? '',
            verificationType: extra?['verificationType'] ?? 'register',
          );
        },
      ),
      
      // Payment Status Route
      GoRoute(
        path: '${RouteNames.paymentStatus}/:transactionId',
        name: RouteNames.paymentStatus,
        builder: (context, state) {
          final transactionId = state.pathParameters['transactionId']!;
          return PaymentStatusScreen(transactionId: transactionId);
        },
      ),
      
      // ============================================================================
      // 🎯 Dashboard (Home)
      // ============================================================================
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const DashboardScreen(),
      ),
      
      // Transaction Routes
      GoRoute(
        path: RouteNames.transactions,
        name: RouteNames.transactions,
        builder: (context, state) => const TransactionsScreen(),
      ),
      GoRoute(
        path: '${RouteNames.transactionDetail}/:id',
        name: RouteNames.transactionDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TransactionDetailScreen(transactionId: id);
        },
      ),
      
      // Transfer Routes
      GoRoute(
        path: RouteNames.transfer,
        name: RouteNames.transfer,
        builder: (context, state) => const TransferScreen(),
      ),
      
      // Payment Routes
      GoRoute(
        path: RouteNames.payments,
        name: RouteNames.payments,
        builder: (context, state) => const PaymentsScreen(),
      ),
      
      // Profile Routes
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      
      // Notification Routes
      GoRoute(
        path: RouteNames.notifications,
        name: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    
    // Error builder
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Route: ${state.uri.path}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
}