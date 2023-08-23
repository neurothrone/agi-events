import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../core/constants/constants.dart';

class CustomSlideTransition extends CustomTransitionPage<void> {
  CustomSlideTransition({
    super.key,
    required super.child,
  }) : super(
          transitionDuration: const Duration(
            milliseconds: AppConstants.animationDuration,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(1.5, 0),
                  end: Offset.zero,
                ).chain(
                  CurveTween(curve: Curves.ease),
                ),
              ),
              child: child,
            );
          },
        );
}
