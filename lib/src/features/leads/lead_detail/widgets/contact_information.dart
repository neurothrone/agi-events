import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';

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
