import 'package:flutter/material.dart';
import 'screens/permissions_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/calibration_screen.dart';

void main() => runApp(const OpticiaApp());

class OpticiaApp extends StatelessWidget {
  const OpticiaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Opticia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C5CFF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F1117),
        cardTheme: const CardTheme(
          color: Color(0x151A1F2E),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          elevation: 0,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
      initialRoute: '/permissions',
      routes: {
        '/permissions': (_) => const PermissionsScreen(),
        '/auth': (_) => const AuthScreen(),
        '/home': (_) => const HomeScreen(),
        '/calibration': (_) => const CalibrationScreen(),
      },
    );
  }
}
