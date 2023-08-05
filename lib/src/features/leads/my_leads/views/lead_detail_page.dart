import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../add_lead/data/leads_controller.dart';

class LeadDetailPage extends StatefulWidget {
  const LeadDetailPage({
    super.key,
    required this.lead,
  });

  final Lead lead;

  @override
  State<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.lead.notes ?? "");
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Lead"),
        actions: [
          SaveNotesButton(
            lead: widget.lead,
            notesController: _notesController,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContactInformation(lead: widget.lead),
              const SizedBox(height: 10.0),
              NotesTextArea(
                lead: widget.lead,
                notesController: _notesController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SaveNotesButton extends ConsumerWidget {
  const SaveNotesButton({
    super.key,
    required this.lead,
    required this.notesController,
  });

  final Lead lead;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(leadsControllerProvider.notifier).updateLeadNotes(
              lead.copyWith(notes: notesController.text),
            );
        Navigator.of(context).pop();
      },
      child: Text(
        "Save",
        style: TextStyle(
          fontSize: 18.0,
          color: AppConstants.primaryBlueLightest,
        ),
      ),
    );
  }
}

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

class ContactInformation extends StatelessWidget {
  const ContactInformation({
    super.key,
    required this.lead,
  });

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contact Information",
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(lead.fullName),
        const SizedBox(height: 10.0),
        Text(lead.company),
        const SizedBox(height: 10.0),
        Text(lead.email),
        const SizedBox(height: 10.0),
        if (lead.phone != null) Text("tel: ${lead.phone}"),
        const SizedBox(height: 40.0),
        const Text(
          "Additional Information",
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
      ],
    );
  }
}
