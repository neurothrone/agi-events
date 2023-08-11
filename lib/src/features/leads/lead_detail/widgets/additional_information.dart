import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';
import 'lead_detail_header_text.dart';

class AdditionalInformation extends StatelessWidget {
  const AdditionalInformation({
    super.key,
    required this.lead,
  });

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LeadDetailHeaderText(
            title: "Additional Information",
          ),
          if (lead.product != null) ...[
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text(
                  "Product(s): ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(lead.product!),
              ],
            ),
          ],
          if (lead.seller != null) ...[
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text(
                  "Seller: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(lead.seller!),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
