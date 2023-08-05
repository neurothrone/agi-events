import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/core/constants/assets_constants.dart';
import 'src/core/firebase/firebase_options.dart';
import 'src/core/fake/repositories/fake_realtime_repository.dart';
import 'src/core/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: temporary for development
  localJsonData = await loadJsonFromAssets(AssetsConstants.localJsonData);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}
