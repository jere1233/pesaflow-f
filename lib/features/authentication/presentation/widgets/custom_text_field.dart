import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool enabled;
  final int? maxLines;
  final String? prefixText;
  final int? maxLength;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
    this.maxLines = 1,
    this.prefixText,
    this.maxLength,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38),
        prefixIcon: Icon(prefixIcon, size: 20, color: Colors.black54),
        suffixIcon: suffixIcon,
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: Colors.black87, fontSize: 15),
        filled: true,
        fillColor: Colors.grey[50],
        counterText: maxLength != null ? null : '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}