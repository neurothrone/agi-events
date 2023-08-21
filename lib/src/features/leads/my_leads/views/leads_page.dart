import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';
import '../widgets/leads_page_app_bar.dart';
import '../widgets/qr_scanner_button.dart';
import '../widgets/leads_page_content.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LeadsPageAppBar(event: event),
      bottomNavigationBar: QrScannerButton(event: event),
      body: LeadsPageContentScrollView(event: event),
    );
  }
}
