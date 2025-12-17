import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'logout_dialog.dart';

class LogoutButton extends StatelessWidget {
  final bool isIconButton;
  final String? text;
  final IconData icon;

  const LogoutButton({
    super.key,
    this.isIconButton = false,
    this.text,
    this.icon = Icons.logout_rounded,
  });

  @override
  Widget build(BuildContext context) {
    if (isIconButton) {
      return IconButton(
        icon: Icon(icon),
        onPressed: () => LogoutDialog.show(context),
        tooltip: 'Logout',
      );
    }

    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.error,
      ),
      title: Text(
        text ?? 'Logout',
        style: const TextStyle(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () => LogoutDialog.show(context),
    );
  }
}