import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:risei/theme_colors.dart';
import 'screens/tasks_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/wellbeing_screen.dart';
import 'screens/joke_screen.dart';
import 'main_navigation.dart';

// Only import and use themes from theme_colors.dart!
const List<Locale> supportedLocales = [
  Locale('en', 'US'),
  Locale('ja', 'JP'),
  Locale('bn', 'BD'),
  Locale('es', 'ES'),
  Locale('fr', 'FR'),
  Locale('ar', 'EG'),
  Locale('zh', 'CN'),
];

void main() => runApp(const RiseiApp());

class RiseiApp extends StatefulWidget {
  const RiseiApp({Key? key}) : super(key: key);

  @override
  State<RiseiApp> createState() => _RiseiAppState();
}

class _RiseiAppState extends State<RiseiApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = supportedLocales[0];
  RiseiTheme _currentTheme = purpleCyanTheme; // Use your imported default theme

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void setTheme(RiseiTheme theme) {
    setState(() {
      _currentTheme = theme;
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Risei',
      locale: _locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: _currentTheme.primarySwatch,
        fontFamily: 'Nunito',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        primarySwatch: _currentTheme.primarySwatch,
        fontFamily: 'Nunito',
      ),
      themeMode: _themeMode,
      home: MainNavigation(
        themeMode: _themeMode,
        onThemeModeChanged: setThemeMode,
        primarySwatch: _currentTheme.primarySwatch,
        onSwatchChanged: (swatch) {
          setState(() {
            // When you create a new RiseiTheme, supply all required fields!
            _currentTheme = RiseiTheme(
              primarySwatch: swatch,
              backgroundGradient: _currentTheme.backgroundGradient,
              accentCyan: _currentTheme.accentCyan,
              accentYellow: _currentTheme.accentYellow,
              accentBlue: _currentTheme.accentBlue,
              accentGreen: _currentTheme.accentGreen,
              accentRed: _currentTheme.accentRed,
              accentPurple: _currentTheme.accentPurple,
              textWhite: _currentTheme.textWhite,
              textFaint: _currentTheme.textFaint,
            );
          });
        },
        locale: _locale,
        onLocaleChanged: setLocale,
        riseiTheme: _currentTheme,
        onThemeChanged: setTheme,
      ),
    );
  }
}
