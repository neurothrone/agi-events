import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';

class NotesTextArea extends StatelessWidget {
  const NotesTextArea({
    super.key,
    required this.lead,
    required this.notesController,
  });

  final Lead lead;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: notesController,
      hintText: "Enter text here...",
      maxLines: 10,
      isRequired: false,
    );
  }
}
