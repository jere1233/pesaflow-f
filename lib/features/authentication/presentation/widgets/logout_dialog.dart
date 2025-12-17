import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/routes/route_names.dart';
import '../providers/auth_provider.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.logout_rounded,
            color: AppColors.error,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Logout',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: const Text(
        'Are you sure you want to logout?',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return ElevatedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.pop(context); // Close dialog
                        context.go(RouteNames.login); // Navigate to login
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                disabledBackgroundColor: AppColors.error.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: authProvider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }

  /// Show logout dialog
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const LogoutDialog(),
    );
  }
}