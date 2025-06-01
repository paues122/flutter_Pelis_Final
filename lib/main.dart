import 'package:flutter/material.dart';
import 'package:tap2025/screens/challenge_screen.dart';
import 'package:tap2025/screens/contador_screen.dart';
import 'package:tap2025/screens/dashboard_screen.dart';
import 'package:tap2025/screens/detail_popular_movie.dart';
import 'package:tap2025/screens/favorites_screen.dart';
import 'package:tap2025/screens/login_screen.dart';
import 'package:tap2025/screens/popular_screen.dart';
import 'package:tap2025/utils/theme_settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeSettings.setTheme(0), // Tema oscuro por defecto
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/dash': (context) => DashboardScreen(),
        '/reto': (context) => ChallengeScreen(),
        '/api': (context) => PopularScreen(),
        '/favorites': (context) => FavoritesScreen(),
        '/detail': (context) => DetailPopularMovie(),
      },
    );
  }
}