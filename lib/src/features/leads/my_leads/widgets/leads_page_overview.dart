import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/models.dart';
import '../../../../core/utils/utils.dart';
import '../../add_lead/views/add_lead_sheet.dart';
import 'add_lead_icon_button.dart';

class LeadsPageOverview extends StatelessWidget {
  const LeadsPageOverview({
    super.key,
    required this.event,
  });

  final Event event;

  void _showAddLeadSheet(BuildContext context) {
    showCustomBottomSheet(
      context: context,
      child: AddLeadSheet(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100.0,
          child: Hero(
            tag: "event-${event.eventId}",
            child: AppEnvironment.isInTestMode
                ? const Placeholder()
                : SvgPicture.asset(
                    AssetsConstants.imagePath(event.image),
                  ),
          ),
        ),
        const SizedBox(height: 20.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Your leads",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            AddLeadIconButton(
              onTap: () => _showAddLeadSheet(context),
            ),
          ],
        ),
        const Divider(color: Colors.white12),
      ],
    );
  }
}
