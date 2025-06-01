import 'package:flutter/material.dart';
import 'package:tap2025/screens/challenge_screen.dart';
import 'package:tap2025/screens/dashboard_screen.dart';
import 'package:tap2025/screens/login_screen.dart';
import 'package:tap2025/screens/popular_screen.dart';
import 'package:tap2025/screens/favorites_screen.dart';
import 'package:tap2025/utils/global_values.dart';
import 'package:tap2025/utils/theme_settings.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalValues.themeMode,
      builder: (context, value, widget) {
        return MaterialApp(
          theme: ThemeSettings.setTheme(value),
          home: const LoginScreen(),
          routes: {
            "/dash": (context) => const DashboardScreen(),
            "/api": (context) => const PopularScreen(),
            "/favorites": (context) => const FavoritesScreen(),
            "/reto": (context) => const ChallengeScreen(),
          },
        );
      },
    );
  }
}