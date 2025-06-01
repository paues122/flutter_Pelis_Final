import 'package:flutter/material.dart';

class GlobalValues {
  static ValueNotifier<int> themeMode = ValueNotifier<int>(0);
  static ValueNotifier<List<int>> favoriteMovieIds = ValueNotifier<List<int>>([]);
}