import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DoneStreakApp());
}

class DoneStreakApp extends StatelessWidget {
  const DoneStreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoneStreak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0714),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC15E),
          brightness: Brightness.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
