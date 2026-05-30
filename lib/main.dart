import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/measurement_repository.dart';
import 'data/services/firebase_measurement_service.dart';
import 'presentation/screens/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final repository = MeasurementRepository(FirebaseMeasurementService());

  runApp(
    ProviderScope(
      overrides: [measurementRepositoryProvider.overrideWithValue(repository)],
      child: const AppGranja(),
    ),
  );
}

class AppGranja extends StatelessWidget {
  const AppGranja({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monitor de RPM',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const HomeShell(),
    );
  }
}
