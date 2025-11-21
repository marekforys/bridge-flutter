import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'Bridge Card Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green[800],
          colorScheme: ColorScheme.light(
            primary: Colors.green[800]!,
            secondary: Colors.green[600]!,
          ),
          useMaterial3: false, // Disable Material 3 for better compatibility
          appBarTheme: AppBarTheme(
            color: Colors.green[800],
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            elevation: 0,
          ),
          // Use the default card theme to avoid type issues
        ),
        home: const GameScreen(),
      ),
    );
  }
}
