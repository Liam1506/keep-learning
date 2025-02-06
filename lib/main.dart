import 'package:flutter/material.dart';
import 'package:keep_learning/Data/Porviders/themeProvider.dart';
import 'package:keep_learning/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => ThemeProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
