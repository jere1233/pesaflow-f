import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DropdownField extends StatelessWidget {
  final String? value;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const DropdownField({
    super.key,
    required this.value,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38),
        prefixIcon: Icon(prefixIcon, size: 20, color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[50],
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
      dropdownColor: Colors.white,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
      ),
    );
  }
}