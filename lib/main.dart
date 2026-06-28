import 'package:flutter/material.dart';
import 'package:ziyadbooks_test/app.dart';
import 'package:ziyadbooks_test/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();

  runApp(const App());
}
