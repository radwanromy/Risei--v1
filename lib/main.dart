import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/tasks_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/wellbeing_screen.dart';
import 'screens/joke_screen.dart';
import 'theme_colors.dart';
import 'main_navigation.dart';

const List<Locale> supportedLocales = [
  Locale('en', 'US'),
  Locale('ja', 'JP'),
  Locale('bn', 'BD'),
  Locale('es', 'ES'),
  Locale('fr', 'FR'),
  Locale('ar', 'EG'),
  Locale('zh', 'CN'),
];

const Map<String, String> languageNames = {
  'en': 'English',
  'ja': '日本語',
  'bn': 'বাংলা',
  'es': 'Español',
  'fr': 'Français',
  'ar': 'العربية',
  'zh': '中文',
};

void main() => runApp(const RiseiApp());

class RiseiApp extends StatefulWidget {
  const RiseiApp({Key? key}) : super(key: key);

  @override
  State<RiseiApp> createState() => _RiseiAppState();
}

class _RiseiAppState extends State<RiseiApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  MaterialColor _primarySwatch = Colors.indigo;
  Locale _locale = supportedLocales[0];

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void setPrimarySwatch(MaterialColor swatch) {
    setState(() {
      _primarySwatch = swatch;
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
        primarySwatch: _primarySwatch,
        fontFamily: 'Nunito',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        primarySwatch: _primarySwatch,
        fontFamily: 'Nunito',
      ),
      themeMode: _themeMode,
      home: MainNavigation(
        themeMode: _themeMode,
        onThemeModeChanged: setThemeMode,
        primarySwatch: _primarySwatch,
        onSwatchChanged: setPrimarySwatch,
        locale: _locale,
        onLocaleChanged: setLocale,
      ),
    );
  }
}
