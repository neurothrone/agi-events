import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/models.dart';
import '../../my_leads/data/leads_controller.dart';
import '../widgets/contact_information.dart';
import '../widgets/lead_detail_page_app_bar.dart';
import '../widgets/notes_text_area.dart';
import '../widgets/unsaved_changes_dialog.dart';

class LeadDetailPage extends StatefulWidget {
  const LeadDetailPage({
    super.key,
    required this.lead,
  });

  final Lead lead;

  static MaterialPageRoute<void> route({required Lead lead}) =>
      MaterialPageRoute(
        builder: (context) => LeadDetailPage(
          lead: lead,
        ),
      );

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

  Future<void> _onCancel(WidgetRef ref) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    final navigator = Navigator.of(context);

    // Temporarily disable the text field's focus when the dialog appears
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    final String leadNotes = widget.lead.notes ?? "";
    if (leadNotes != _notesController.text) {
      bool? hasUnsavedChanges = await showUnsavedChangesDialog(context);
      if (hasUnsavedChanges != null && hasUnsavedChanges) {
        _saveChanges(ref);
      }
    }

    navigator.pop();
  }

  Future<bool?> showUnsavedChangesDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const UnsavedChangesDialog();
      },
    );
  }

  Future<void> _onSave(WidgetRef ref) async {
    _saveChanges(ref);
    Navigator.of(context).pop();
  }

  Future<void> _saveChanges(WidgetRef ref) async {
    ref.read(leadsControllerProvider.notifier).updateLeadNotes(
          widget.lead.copyWith(notes: _notesController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer(
          builder: (_, ref, __) {
            return LeadDetailPageAppBar(
              onCancel: () => _onCancel(ref),
              onSave: () => _onSave(ref),
            );
          },
        ),
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
