import 'package:flutter/material.dart';

class RiseiTheme {
  final LinearGradient backgroundGradient;
  final MaterialColor primarySwatch;
  final Color accentCyan;
  final Color accentYellow;
  final Color accentBlue;
  final Color accentGreen;
  final Color accentRed;
  final Color accentPurple;
  final Color textWhite;
  final Color textFaint;

  RiseiTheme({
    required this.backgroundGradient,
    required this.primarySwatch,
    required this.accentCyan,
    required this.accentYellow,
    required this.accentBlue,
    required this.accentGreen,
    required this.accentRed,
    required this.accentPurple,
    required this.textWhite,
    required this.textFaint,
  });
}

final RiseiTheme purpleCyanTheme = RiseiTheme(
  backgroundGradient: const LinearGradient(
    colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  primarySwatch: Colors.indigo,
  accentCyan: const Color(0xFF06B6D4),
  accentYellow: const Color(0xFFF59E42),
  accentBlue: const Color(0xFF3B82F6),
  accentGreen: const Color(0xFF10B981),
  accentRed: const Color(0xFFEF4444),
  accentPurple: const Color(0xFF8B5CF6),
  textWhite: Colors.white,
  textFaint: Colors.white70,
);

final RiseiTheme orangePinkTheme = RiseiTheme(
  backgroundGradient: const LinearGradient(
    colors: [Color(0xFFFFA726), Color(0xFFFF6F61), Color(0xFFE040FB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  primarySwatch: Colors.orange,
  accentCyan: const Color(0xFF26C6DA),
  accentYellow: const Color(0xFFFFEB3B),
  accentBlue: const Color(0xFF1976D2),
  accentGreen: const Color(0xFF43A047),
  accentRed: const Color(0xFFD32F2F),
  accentPurple: const Color(0xFFBA68C8),
  textWhite: Colors.white,
  textFaint: Colors.white70,
);

final RiseiTheme blueGreenTheme = RiseiTheme(
  backgroundGradient: const LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF43A047), Color(0xFFB2FF59)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  primarySwatch: Colors.blue,
  accentCyan: const Color(0xFF00BCD4),
  accentYellow: const Color(0xFFFFEB3B),
  accentBlue: const Color(0xFF1976D2),
  accentGreen: const Color(0xFF43A047),
  accentRed: const Color(0xFFD32F2F),
  accentPurple: const Color(0xFF7C4DFF),
  textWhite: Colors.white,
  textFaint: Colors.white70,
);

final RiseiTheme redAmberTheme = RiseiTheme(
  backgroundGradient: const LinearGradient(
    colors: [Color(0xFFD32F2F), Color(0xFFFFA000), Color(0xFFFFD54F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  primarySwatch: Colors.red,
  accentCyan: const Color(0xFF00ACC1),
  accentYellow: const Color(0xFFFFEB3B),
  accentBlue: const Color(0xFF1976D2),
  accentGreen: const Color(0xFF388E3C),
  accentRed: const Color(0xFFD32F2F),
  accentPurple: const Color(0xFF8E24AA),
  textWhite: Colors.white,
  textFaint: Colors.white70,
);
