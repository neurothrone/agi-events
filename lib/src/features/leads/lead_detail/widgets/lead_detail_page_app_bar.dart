import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

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
    return Platform.isIOS
        ? CustomCupertinoAppBar(
            onBackButtonPressed: onCancel,
            title: "Lead",
            trailing: TextButton(
              onPressed: onSave,
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: 18.0,
                  color: AppConstants.primaryBlueLightest,
                ),
              ),
            ),
          )
        : AppBar(
            leading: BackButton(onPressed: onCancel),
            centerTitle: true,
            title: const Text(
              "Lead",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
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
          );
  }
}
