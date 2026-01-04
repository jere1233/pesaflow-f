// lib/features/authentication/presentation/widgets/password_text_field.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final String? labelText;
  final String? hintText;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.labelText,
    this.hintText,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF2D3748),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText ?? 'Password',
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        floatingLabelStyle: TextStyle(
          color: const Color(0xFF667eea),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          height: 1.5, // ✅ FIXES LABEL CUT-OFF
        ),
        hintText: widget.hintText ?? 'Enter your password',
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: Icon(
            Icons.lock_outline_rounded,
            size: 22,
            color: Colors.grey.shade600,
          ),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Icon(
              _obscureText 
                  ? Icons.visibility_off_outlined 
                  : Icons.visibility_outlined,
              size: 22,
              color: Colors.grey.shade600,
            ),
            onPressed: () {
              setState(() => _obscureText = !_obscureText);
            },
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        
        // ✅ FIXED PADDING - Extra top padding for floating label
        contentPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20, // ✅ Extra top padding
          bottom: 16,
        ),
        
        // Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        
        // Enabled border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        
        // Focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF667eea),
            width: 2,
          ),
        ),
        
        // Error border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 1.5,
          ),
        ),
        
        // Focused error border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red.shade600,
            width: 2,
          ),
        ),
        
        errorStyle: TextStyle(
          fontSize: 12,
          color: Colors.red.shade600,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
        
        errorMaxLines: 2,
      ),
    );
  }
}