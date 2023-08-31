import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

class LeadDetailPageAppBar extends StatelessWidget {
  const LeadDetailPageAppBar({
    super.key,
    required this.onBackPressed,
    required this.onDeletePressed,
  });

  final VoidCallback onBackPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CustomCupertinoAppBar(
            onBackButtonPressed: onBackPressed,
            title: "Lead",
            trailing: LeadDetailAppBarDeleteButton(onPressed: onDeletePressed),
          )
        : AppBar(
            leading: BackButton(onPressed: onBackPressed),
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
              LeadDetailAppBarDeleteButton(onPressed: onDeletePressed),
            ],
          );
  }
}

class LeadDetailAppBarDeleteButton extends StatelessWidget {
  const LeadDetailAppBarDeleteButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        "Delete",
        style: TextStyle(
          fontSize: 18.0,
          color: AppConstants.destructive,
        ),
      ),
    );
  }
}
