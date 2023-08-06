import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class LeadDetailPageAppBar extends StatelessWidget {
  const LeadDetailPageAppBar({
    super.key,
    required this.onCancel,
    this.onSave,
  });

  final VoidCallback onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0.0, // Remove default title spacing
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Text("Lead"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onCancel,
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppConstants.destructive,
                  ),
                ),
              ),
              TextButton(
                onPressed: onSave,
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
        ],
      ),
    );
  }
}
