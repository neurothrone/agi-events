import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.onFieldSubmitted,
    this.controller,
    this.labelText,
    required this.hintText,
    this.keyboardType,
    this.maxLines,
    this.readOnly,
    this.isRequired = true,
    this.primaryColor,
    this.filled = false,
    this.focusNode,
    this.textCapitalization = TextCapitalization.sentences,
    this.textInputAction,
    this.fieldKey,
  });

  final Function(String)? onFieldSubmitted;
  final TextEditingController? controller;
  final String? labelText;
  final String hintText;
  final bool isRequired;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool? readOnly;
  final Color? primaryColor;
  final bool? filled;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      readOnly: readOnly ?? false,
      style: const TextStyle(
        color: Colors.white,
      ),
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType ?? TextInputType.text,
      cursorColor: primaryColor ?? AppConstants.primaryBlueLightest,
      decoration: InputDecoration(
        filled: filled,
        alignLabelWithHint: true,
        labelText: isRequired ? "$labelText*" : labelText,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyle(
          color: primaryColor ?? AppConstants.primaryBlueLightest,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.elevation),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor ?? AppConstants.primaryBlueLightest,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.elevation),
        ),
      ),
    );
  }
}
