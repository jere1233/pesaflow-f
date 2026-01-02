import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final bool obscureText;

  const PinTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.validator,
    this.textInputAction,
    this.obscureText = false, // Numbers visible by default
  });

  @override
  State<PinTextField> createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  bool _isObscured = false; // Start with numbers VISIBLE

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.95),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            // Light background so BLACK dots are visible
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _isObscured,
            obscuringCharacter: '●', // Black dot
            keyboardType: TextInputType.number,
            textInputAction: widget.textInputAction,
            maxLength: 4,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            style: TextStyle(
              fontSize: 28,
              // Black text for numbers AND dots
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              letterSpacing: 12.0,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText ?? (_isObscured ? '● ● ● ●' : '1  2  3  4'),
              hintStyle: TextStyle(
                color: Colors.black26, // Light grey hint
                letterSpacing: 12.0,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(
                  Icons.pin_outlined,
                  color: Colors.black54, // Dark grey icon
                  size: 26,
                ),
              ),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black87, // BLACK icon - very visible
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  tooltip: _isObscured ? 'Show PIN' : 'Hide PIN',
                ),
              ),
              counterText: '',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 22,
              ),
              errorStyle: const TextStyle(
                fontSize: 12,
                color: Color(0xFFD32F2F),
                fontWeight: FontWeight.w600,
              ),
            ),
            validator: widget.validator,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  'Enter a 4-digit PIN for account security',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                '${widget.controller.text.length}/4',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}