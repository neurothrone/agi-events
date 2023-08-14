import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class AddLeadIconButton extends StatelessWidget {
  const AddLeadIconButton({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.primaryBlueLighter,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            key: const Key("addLeadManualButton"),
            borderRadius: BorderRadius.circular(10.0),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
                semanticLabel: "Add",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
