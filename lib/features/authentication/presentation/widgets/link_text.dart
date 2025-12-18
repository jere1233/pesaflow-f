import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LinkText extends StatelessWidget {
  final String normalText;
  final String linkText;
  final VoidCallback onTap;
  final Color? normalTextColor;
  final Color? linkTextColor;

  const LinkText({
    super.key,
    required this.normalText,
    required this.linkText,
    required this.onTap,
    this.normalTextColor,
    this.linkTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            normalText,
            style: TextStyle(
              fontSize: 14,
              color: normalTextColor ?? AppColors.textSecondary,
            ),
          ),
          Text(
            linkText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: linkTextColor ?? AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: linkTextColor ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}