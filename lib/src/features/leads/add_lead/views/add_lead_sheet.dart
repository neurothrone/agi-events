import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../widgets/add_lead_form.dart';

class AddLeadSheet extends StatelessWidget {
  const AddLeadSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.sheetBackgroundColor,
      body: SafeArea(
        minimum: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddLeadTitleText(),
            const Divider(color: Colors.white24),
            Expanded(
              child: ListView(
                children: const [
                  SizedBox(height: 10.0),
                  AddLeadForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddLeadTitleText extends StatelessWidget {
  const AddLeadTitleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "New lead",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
