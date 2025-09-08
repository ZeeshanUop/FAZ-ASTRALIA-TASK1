import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light(Color seed) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    ),
  );

  static ThemeData dark(Color seed) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    ),
  );

  // ✅ Explicitly typed as List<Color>
  static const List<Color> presetSeeds = <Color>[
    Colors.teal,
    Colors.deepOrange,
    Colors.indigo,
    Colors.green,
  ];
}
