import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      prefixIcon: Icons.lock_outline,
      obscureText: _obscurePassword,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          size: 20,
          color: Colors.black54,
        ),
        onPressed: () {
          setState(() => _obscurePassword = !_obscurePassword);
        },
      ),
    );
  }
}