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
    this.borderRadius = 14,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (buttonType == ButtonType.outline) {
      return SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: icon != null
              ? OutlinedButton.icon(
                  onPressed: isLoading ? null : onPressed,
                  icon: Icon(
                    icon,
                    size: 22,
                    color: textColor ?? Colors.white,
                  ),
                  label: _buildButtonContent(),
                  style: _outlineButtonStyle(),
                )
              : OutlinedButton(
                  onPressed: isLoading ? null : onPressed,
                  style: _outlineButtonStyle(),
                  child: _buildButtonContent(),
                ),
        ),
      );
    }

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: (backgroundColor ?? Colors.white).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: icon != null
            ? ElevatedButton.icon(
                onPressed: isLoading ? null : onPressed,
                icon: Icon(
                  icon,
                  color: textColor ?? AppColors.primary,
                  size: 22,
                ),
                label: _buildButtonContent(),
                style: _elevatedButtonStyle(),
              )
            : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: _elevatedButtonStyle(),
                child: _buildButtonContent(),
              ),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            buttonType == ButtonType.outline
                ? (textColor ?? Colors.white)
                : (textColor ?? AppColors.primary),
          ),
        ),
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: buttonType == ButtonType.outline
            ? (textColor ?? Colors.white)
            : (textColor ?? AppColors.primary),
      ),
    );
  }

  ButtonStyle _elevatedButtonStyle() {
    Color bgColor;
    switch (buttonType) {
      case ButtonType.primary:
        bgColor = backgroundColor ?? Colors.white;
        break;
      case ButtonType.secondary:
        bgColor = backgroundColor ?? AppColors.highlightGold;
        break;
      default:
        bgColor = backgroundColor ?? Colors.white;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      disabledBackgroundColor: bgColor.withOpacity(0.6),
      foregroundColor: textColor ?? AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    );
  }

  ButtonStyle _outlineButtonStyle() {
    return OutlinedButton.styleFrom(
      backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.1),
      side: BorderSide(
        color: (backgroundColor ?? Colors.white).withOpacity(0.4),
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    );
  }
}