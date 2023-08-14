import 'dart:io';

class AppEnvironment {
  const AppEnvironment._();

  static final isInTestMode = Platform.environment.containsKey("FLUTTER_TEST");
}
