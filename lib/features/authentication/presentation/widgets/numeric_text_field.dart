import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

class NumericTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final String? prefixText;
  final String? suffixText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool allowDecimal;
  final List<String>? quickSelectOptions; // New parameter for quick selection

  const NumericTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    this.prefixText,
    this.suffixText,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.allowDecimal = true,
    this.quickSelectOptions,
  });

  @override
  State<NumericTextField> createState() => _NumericTextFieldState();
}

class _NumericTextFieldState extends State<NumericTextField> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    // Check if current value matches any quick select option
    if (widget.quickSelectOptions != null) {
      final currentValue = widget.controller.text;
      if (widget.quickSelectOptions!.contains(currentValue)) {
        _selectedOption = currentValue;
      }
    }
  }

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
      widget.controller.text = option;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(option);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.numberWithOptions(decimal: widget.allowDecimal),
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          validator: widget.validator,
          onChanged: (value) {
            // Update selected option if value matches
            if (widget.quickSelectOptions != null) {
              setState(() {
                _selectedOption = widget.quickSelectOptions!.contains(value) ? value : null;
              });
            }
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          inputFormatters: [
            if (widget.allowDecimal)
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
            else
              FilteringTextInputFormatter.digitsOnly,
          ],
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: const TextStyle(color: Colors.black54),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.black38),
            prefixIcon: Icon(widget.prefixIcon, size: 20, color: Colors.black54),
            prefixText: widget.prefixText,
            prefixStyle: const TextStyle(color: Colors.black87, fontSize: 15),
            suffixText: widget.suffixText,
            suffixStyle: const TextStyle(color: Colors.black87, fontSize: 15),
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
        ),
        
        // Quick select chips
        if (widget.quickSelectOptions != null && widget.quickSelectOptions!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.quickSelectOptions!.map((option) {
              final isSelected = _selectedOption == option;
              return InkWell(
                onTap: () => _selectOption(option),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    '$option${widget.suffixText ?? ''}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
