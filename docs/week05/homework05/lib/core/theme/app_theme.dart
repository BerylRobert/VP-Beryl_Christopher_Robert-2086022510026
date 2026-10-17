import 'package:flutter/material.dart';

const Color _seedColor = Color(0xFFFF640A);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seedColor,
    brightness: Brightness.dark,
  ),
);