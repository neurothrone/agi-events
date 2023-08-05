import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../widgets/contact_information.dart';
import '../widgets/notes_text_area.dart';
import '../widgets/save_notes_button.dart';

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
        automaticallyImplyLeading: false,
        titleSpacing: 0.0, // Remove default title spacing
        title: Stack(
          alignment: Alignment.center,
          children: [
            const Text("Lead"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppConstants.destructive,
                    ),
                  ),
                ),
                SaveNotesButton(
                  lead: widget.lead,
                  notesController: _notesController,
                ),
              ],
            ),
          ],
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
