import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class TextRowButton extends StatelessWidget {
  const TextRowButton({
    super.key,
    this.onTap,
    required this.text,
  });

  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.blue,
              color: AppConstants.primaryBlueLighter,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10.0),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
