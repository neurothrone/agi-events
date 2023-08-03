import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/widgets/primary_button.dart';
import '../../add_lead/add_lead_sheet.dart';
import '../widgets/lead_row.dart';
import '../widgets/text_row_button.dart';

class LeadsPage extends StatelessWidget {
  const LeadsPage({
    super.key,
    required this.imageAsset,
  });

  final String imageAsset;

  final bool hasItems = false;

  void _shareLeads() {}

  void _showAddLeadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 0.95,
          child: AddLeadSheet(),
        );
      },
    );
  }

  void _scanNewLead() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _shareLeads,
            icon: Icon(
              Platform.isIOS ? CupertinoIcons.share : Icons.share,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PrimaryButton(
          onPressed: _scanNewLead,
          label: "Scan new lead",
          height: 50.0,
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 100.0,
                    child: SvgPicture.asset(imageAsset),
                  ),
                  const SizedBox(height: 20.0),
                  TextRowButton(
                    text: "Your leads",
                    onTap: () => _showAddLeadSheet(context),
                  ),
                  const Divider(color: Colors.white12),
                  if (!hasItems) ...[
                    const SizedBox(height: 20.0),
                    const Text(
                      "You have no leads yet",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasItems)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => const LeadRow(),
                  childCount: 20,
                ),
              )
          ],
        ),
      ),
    );
  }
}
