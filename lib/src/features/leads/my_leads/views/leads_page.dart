import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/qr_scanner_button.dart';
import '../widgets/leads_page_content.dart';
import '../widgets/share_button.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({
    super.key,
    required this.event,
  });

  final Event event;

  static MaterialPageRoute<void> route({required Event event}) =>
      MaterialPageRoute(
        builder: (context) => LeadsPage(
          event: event,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CustomCupertinoAppBar(
                trailing: ShareButton(event: event),
              ),
            )
          : AppBar(
              actions: [
                ShareButton(event: event),
              ],
            ),
      bottomNavigationBar: QrScannerButton(event: event),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20.0),
        child: LeadsPageContentScrollView(event: event),
      ),
    );
  }
}
