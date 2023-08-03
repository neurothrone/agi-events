import 'package:flutter/material.dart';

import '../../../../core/widgets/primary_button.dart';
import '../widgets/add_lead_form.dart';

class AddLeadSheet extends StatelessWidget {
  const AddLeadSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        minimum: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Faux indicator to make it intuitive for the user that the
            // sheet can be dragged vertically
            const Align(
              alignment: Alignment.topCenter,
              child: SheetDragIndicator(),
            ),
            const SizedBox(height: 20.0),
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

class SheetDragIndicator extends StatelessWidget {
  const SheetDragIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 5.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
