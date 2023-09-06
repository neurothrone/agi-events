import 'dart:io';

import 'package:flutter/cupertino.dart';
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
    return AppBar(
      leading: IconButton(
        onPressed: onBackPressed,
        icon: const Icon(
          Icons.check,
          color: Colors.green,
          size: 30.0,
        ),
        tooltip: "Save",
      ),
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
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.trash : Icons.delete,
        size: 24.0,
      ),
      color: AppConstants.primaryBlueLighter,
      tooltip: "Delete",
    );
  }
}
