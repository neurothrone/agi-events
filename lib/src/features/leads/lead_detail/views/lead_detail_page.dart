import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../my_leads/data/leads_controller.dart';
import '../../my_leads/widgets/lead_delete_button.dart';
import '../widgets/contact_information.dart';
import '../widgets/lead_detail_header_text.dart';
import '../widgets/lead_detail_page_app_bar.dart';
import '../widgets/notes_text_area.dart';
import '../widgets/custom_alert_dialog.dart';

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

  Future<void> _saveChanges(WidgetRef ref) async {
    ref.read(leadsControllerProvider.notifier).updateLeadNotes(
          widget.lead.copyWith(notes: _notesController.text),
        );
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
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: "You have unsaved changes",
            content: "Do you want to save them?",
            cancelText: "Discard",
            confirmText: "Save",
            cancelColor: AppConstants.destructive,
            confirmColor: AppConstants.secondaryBlue,
            onCancel: () {
              // TODO: Do nothing
            },
            onConfirm: () {
              _saveChanges(ref);
            },
          );
        },
      );
    }

    navigator.pop();
  }

  Future<void> _onSave(WidgetRef ref) async {
    _saveChanges(ref);
    Navigator.of(context).pop();
  }

  void _onDelete(WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: "Delete Lead",
          content: "This will delete your Lead from the database. "
              "Are you sure?",
          cancelText: "Cancel",
          confirmText: "Delete",
          cancelColor: AppConstants.secondaryBlue,
          confirmColor: AppConstants.destructive,
          onCancel: () {},
          onConfirm: () {
            // TODO: Delete Lead from database and pop navigator
          },
        );
      },
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
        child: LayoutBuilder(
          builder: (context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LeadDetailHeaderText(
                          title: "Contact Information",
                        ),
                        const SizedBox(height: 10.0),
                        ContactInformation(lead: widget.lead),
                        const SizedBox(height: 40.0),
                        const LeadDetailHeaderText(
                          title: "Additional Information",
                        ),
                        const SizedBox(height: 10.0),
                        NotesTextArea(
                          lead: widget.lead,
                          notesController: _notesController,
                        ),
                        const SizedBox(height: 40.0),
                        const Spacer(),
                        Consumer(
                          builder: (_, ref, __) {
                            return LeadDeleteButton(
                              onPressed: () => _onDelete(ref),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
