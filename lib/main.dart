import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(SessionAdapter());

  Hive.registerAdapter(SessionStoreDataAdapter());
  Hive.registerAdapter(SessionDailyAdapter());
  // Open Hive boxes
  await Hive.openBox<Session>('sessions');
  final dataStore = DataStore();
  await dataStore.init();
  print(dataStore.isRefreshed());

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
        ChangeNotifierProvider(create: (context) => TimerProvider()), // Ad
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
