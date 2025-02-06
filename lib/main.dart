import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keep_learning/Data/Porviders/sessionProvider.dart';
import 'package:keep_learning/Data/Porviders/themeProvider.dart'; // Import the SessionsProvider
import 'package:keep_learning/Data/models/session_model.dart';
import 'package:keep_learning/router.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(SessionAdapter());

  // Open Hive boxes
  await Hive.openBox<Session>('sessions');

  // Run the app with multiple providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ), // Existing ThemeProvider
        ChangeNotifierProvider(
          create: (context) => SessionsProvider(),
        ), // Add SessionsProvider here
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      title: 'Keep Learning',
      routerConfig: router,
      theme: themeProvider.themeData,
    );
  }
}
