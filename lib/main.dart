import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keep_learning/Data/Classes/notificationService.dart';
import 'package:keep_learning/Data/Porviders/paywallProvider.dart';
import 'package:keep_learning/Data/Porviders/sessionProvider.dart';
import 'package:keep_learning/Data/Porviders/themeProvider.dart'; // Import the SessionsProvider
import 'package:keep_learning/Data/Porviders/timerProvider.dart';
import 'package:keep_learning/Data/Storage/DataStore.dart';
import 'package:keep_learning/Data/models/session_daily.dart';
import 'package:keep_learning/Data/models/session_model.dart';
import 'package:keep_learning/Data/models/session_store_data.dart';
import 'package:keep_learning/router.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Initializing...");

  try {
    // Initialize Hive
    print("Initializing Hive...");
    await Hive.initFlutter();

    // Register adapters
    print("Registering Hive adapters...");
    Hive.registerAdapter(SessionAdapter());
    Hive.registerAdapter(SessionStoreDataAdapter());
    Hive.registerAdapter(SessionDailyAdapter());

    // Open Hive boxes
    print("Opening Hive boxes...");
    await Hive.openBox<Session>('sessions');

    final dataStore = DataStore();
    await dataStore.init();
    print("DataStore initialized successfully.");

    // Uncomment to initialize notifications if needed
    // await NotificationService.init();

    print("Initialization complete.");
  } catch (e) {
    print("Error during initialization: $e");
  }

  // Run the app with multiple providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SessionsProvider()),
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider(create: (context) => PaywallProvider()),
      ],
      child: const MyApp(),
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
