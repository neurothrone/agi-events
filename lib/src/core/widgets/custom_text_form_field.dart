import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.labelText,
    required this.hintText,
    this.keyboardType,
    this.maxLines,
    this.readOnly,
    this.isRequired = true,
    this.primaryColor = Colors.blue,
    this.filled = false,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String hintText;
  final bool isRequired;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool? readOnly;
  final Color primaryColor;
  final bool? filled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly ?? false,
      style: const TextStyle(
        color: Colors.white,
      ),
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType ?? TextInputType.text,
      cursorColor: primaryColor,
      decoration: InputDecoration(
        filled: filled,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: isRequired ? "$labelText*" : labelText,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyle(
          color: primaryColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
