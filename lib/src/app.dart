import 'package:flutter/material.dart';

import 'core/constants/constants.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      title: AppConstants.appTitle,
      routerConfig: AppRouter.router,
    );
  }
}
