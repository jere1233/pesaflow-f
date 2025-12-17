import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum ButtonType { primary, secondary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType buttonType;
  final double? height;
  final double? width;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.buttonType = ButtonType.primary,
    this.height = 50,
    this.width,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (buttonType == ButtonType.outline) {
      return SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: icon != null
            ? OutlinedButton.icon(
                onPressed: isLoading ? null : onPressed,
                icon: Icon(
                  icon,
                  size: 24,
                  color: textColor ?? AppColors.primary,
                ),
                label: _buildButtonContent(),
                style: _outlineButtonStyle(),
              )
            : OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: _outlineButtonStyle(),
                child: _buildButtonContent(),
              ),
      );
    }

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: icon != null
          ? ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: Icon(icon, color: textColor ?? Colors.white),
              label: _buildButtonContent(),
              style: _elevatedButtonStyle(),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: _elevatedButtonStyle(),
              child: _buildButtonContent(),
            ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            buttonType == ButtonType.outline
                ? (textColor ?? AppColors.primary)
                : (textColor ?? Colors.white),
          ),
        ),
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: buttonType == ButtonType.outline
            ? (textColor ?? AppColors.primary)
            : (textColor ?? Colors.white),
      ),
    );
  }

  ButtonStyle _elevatedButtonStyle() {
    Color bgColor;
    switch (buttonType) {
      case ButtonType.primary:
        bgColor = backgroundColor ?? AppColors.primary;
        break;
      case ButtonType.secondary:
        bgColor = backgroundColor ?? AppColors.secondary;
        break;
      default:
        bgColor = backgroundColor ?? AppColors.primary;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      disabledBackgroundColor: bgColor.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
      padding: padding,
    );
  }

  ButtonStyle _outlineButtonStyle() {
    return OutlinedButton.styleFrom(
      side: BorderSide(
        color: backgroundColor ?? AppColors.border,
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
    );
  }
}