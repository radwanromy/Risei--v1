import 'package:flutter/material.dart';

// Main gradient colors (inspired by your reference UI)
const Color kGradientStart = Color(0xFF642B73);     // Deep Purple
const Color kGradientMiddle = Color(0xFFC6426E);    // Magenta
const Color kGradientEnd = Color(0xFF17EAD9);       // Cyan

const Color kAccentCyan = Color(0xFF5DF2F2);        // Vibrant cyan
const Color kAccentYellow = Color(0xFFFFEB3B);      // Yellow for highlights
const Color kAccentBlue = Color(0xFF1FA2FF);        // Blue for accent
const Color kTextWhite = Colors.white;
const Color kTextFaint = Color(0xB3FFFFFF);         // White with 70% opacity

const List<Color> kMainGradient = [
  kGradientStart,
  kGradientMiddle,
  kGradientEnd,
];

const LinearGradient kBackgroundGradient = LinearGradient(
  colors: kMainGradient,
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
