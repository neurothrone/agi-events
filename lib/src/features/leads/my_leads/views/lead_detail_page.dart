import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/custom_text_form_field.dart';

class LeadDetailPage extends StatelessWidget {
  const LeadDetailPage({
    super.key,
    required this.lead,
  });

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Lead"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Save",
              style: TextStyle(
                fontSize: 18.0,
                color: AppConstants.primaryBlueLightest,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
              const SizedBox(height: 10.0),
              // TODO: controller
              const CustomTextFormField(
                hintText: "Enter text here...",
                maxLines: 10,
                isRequired: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
