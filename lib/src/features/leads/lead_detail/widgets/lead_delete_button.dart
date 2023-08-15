import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

class LeadDeleteButton extends StatelessWidget {
  const LeadDeleteButton({
    super.key,
    this.onPressed,
    required this.label,
    required this.width,
    required this.height,
  });

  final VoidCallback? onPressed;
  final String label;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onPressed,
      label: label,
      width: width,
      height: height,
      icon: Platform.isIOS ? CupertinoIcons.trash : Icons.delete,
      backgroundColor: AppConstants.destructive,
    );
  }
}
