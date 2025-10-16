import 'package:flutter/material.dart';
import 'package:matrimony/constants/const_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  const CustomTextField({
    Key? key,
    this.controller,
    this.label,
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
      decoration: InputDecoration(
        labelText: label ?? '',
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