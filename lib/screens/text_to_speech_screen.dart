import 'package:flutter/material.dart';
import '../theme_colors.dart'; // <-- This is REQUIRED

class TextToSpeechScreen extends StatelessWidget {
  final RiseiTheme riseiTheme;
  final Locale locale;
  const TextToSpeechScreen({Key? key, required this.riseiTheme, required this.locale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text to Speech'),
        backgroundColor: riseiTheme.backgroundGradient.colors[1],
      ),
      body: Center(
        child: Text(
          'Text to Speech functionality coming soon!',
          style: TextStyle(fontSize: 20, color: riseiTheme.textWhite),
        ),
      ),
    );
  }
}
