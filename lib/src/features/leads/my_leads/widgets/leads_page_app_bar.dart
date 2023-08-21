import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import 'share_button.dart';

class LeadsPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LeadsPageAppBar({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CustomCupertinoAppBar(
            trailing: ShareButton(event: event),
          )
        : AppBar(
            actions: [
              ShareButton(event: event),
            ],
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
