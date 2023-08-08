import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../widgets/add_lead_form.dart';
import '../widgets/add_lead_title_text.dart';

class AddLeadSheet extends StatelessWidget {
  const AddLeadSheet({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.lighterBlack,
      body: SafeArea(
        minimum: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddLeadTitleText(),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 10.0),
                  AddLeadForm(event: event),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
