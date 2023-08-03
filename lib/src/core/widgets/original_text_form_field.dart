import 'package:flutter/material.dart';

class OriginalTextFormField extends StatelessWidget {
  const OriginalTextFormField({
    super.key,
    this.controller,
    required this.label,
    required this.hintText,
    this.isRequired = true,
  });

  final TextEditingController? controller;
  final String label;
  final String hintText;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isRequired ? "$label*" : label),
        const SizedBox(height: 2.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}
