import 'package:flutter/material.dart';
import 'package:matrimony/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? helperText; // ✅ New field for description
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  const CustomTextField({
    Key? key,
    this.controller,
    this.label,
    this.helperText, // ✅ Constructor update
    this.readOnly = false,
    this.keyboardType,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType ?? TextInputType.text,
      onTap: readOnly ? onTap : null,
      maxLines: label == 'Tell Us About Yourself' ? 4 : 1, // ✅ Optional: make it multiline
      decoration: InputDecoration(
        labelText: label ?? '',
        helperText: helperText, // ✅ Add helper text here
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.textColor,
        ),
        filled: true,
        fillColor: Colors.grey[100],

        // Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),

        // Enabled (unfocused) border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),

        // Focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}
