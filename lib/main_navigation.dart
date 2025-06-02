import 'package:flutter/material.dart';
import 'theme_colors.dart';
import 'screens/learning_screen.dart';
import 'screens/wellbeing_screen.dart';
import 'screens/joke_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/sleep_sounds_screen.dart'; // <-- ADD THIS

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

class MainNavigation extends StatefulWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) onThemeModeChanged;
  final MaterialColor primarySwatch;
  final void Function(MaterialColor) onSwatchChanged;
  final Locale locale;
  final void Function(Locale) onLocaleChanged;

  /// Advanced theme switching support
  final RiseiTheme riseiTheme;
  final void Function(RiseiTheme) onThemeChanged;

  const MainNavigation({
    Key? key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.primarySwatch,
    required this.onSwatchChanged,
    required this.locale,
    required this.onLocaleChanged,
    required this.riseiTheme,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      TasksScreen(
        themeMode: widget.themeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
        primarySwatch: widget.primarySwatch,
        onSwatchChanged: widget.onSwatchChanged,
        locale: widget.locale,
        onLocaleChanged: widget.onLocaleChanged,
        riseiTheme: widget.riseiTheme,
      ),
      const LearningScreen(),
      const WellbeingScreen(),
      const JokeScreen(),
      SleepSoundsScreen(riseiTheme: widget.riseiTheme, locale: widget.locale), // <-- ADD THIS
    ];
  }

  final List<String> _titles = [
    'Tasks',
    'Learning',
    'Well-being',
    'Jokes',
    'Sleep Sounds', // <-- ADD THIS
  ];

  @override
  void didUpdateWidget(covariant MainNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _screens[0] = TasksScreen(
      themeMode: widget.themeMode,
      onThemeModeChanged: widget.onThemeModeChanged,
      primarySwatch: widget.primarySwatch,
      onSwatchChanged: widget.onSwatchChanged,
      locale: widget.locale,
      onLocaleChanged: widget.onLocaleChanged,
      riseiTheme: widget.riseiTheme,
    );
    _screens[4] = SleepSoundsScreen(riseiTheme: widget.riseiTheme, locale: widget.locale);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.riseiTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: theme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            _titles[_currentIndex],
            style: TextStyle(
              color: theme.textWhite,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                widget.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                color: theme.accentYellow,
              ),
              tooltip: "Toggle Theme",
              onPressed: () {
                widget.onThemeModeChanged(
                  widget.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                );
              },
            ),
            PopupMenuButton<MaterialColor>(
              icon: Icon(Icons.color_lens, color: theme.accentCyan),
              tooltip: "Change Primary Color",
              onSelected: (color) => widget.onSwatchChanged(color),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: Colors.indigo,
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.indigo, radius: 10),
                      const SizedBox(width: 8),
                      const Text('Indigo')
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: Colors.pink,
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.pink, radius: 10),
                      const SizedBox(width: 8),
                      const Text('Pink')
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: Colors.teal,
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.teal, radius: 10),
                      const SizedBox(width: 8),
                      const Text('Teal')
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: Colors.amber,
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.amber, radius: 10),
                      const SizedBox(width: 8),
                      const Text('Amber')
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: Colors.deepPurple,
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.deepPurple, radius: 10),
                      const SizedBox(width: 8),
                      const Text('Deep Purple')
                    ],
                  ),
                ),
              ],
            ),
            PopupMenuButton<RiseiTheme>(
              icon: Icon(Icons.palette, color: theme.accentYellow),
              tooltip: "Change App Theme",
              onSelected: widget.onThemeChanged,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: purpleCyanTheme,
                  child: const Text('Purple Cyan'),
                ),
                PopupMenuItem(
                  value: orangePinkTheme,
                  child: const Text('Orange Pink'),
                ),
                PopupMenuItem(
                  value: blueGreenTheme,
                  child: const Text('Blue Green'),
                ),
                PopupMenuItem(
                  value: redAmberTheme,
                  child: const Text('Red Amber'),
                ),
                PopupMenuItem(
                  value: solidBlackTheme,
                  child: const Text('Solid Black'),
                ),
                PopupMenuItem(
                  value: solidWhiteTheme,
                  child: const Text('Solid White'),
                ),
              ],
            ),
            PopupMenuButton<Locale>(
              icon: Icon(Icons.language, color: theme.accentYellow),
              tooltip: "Change Language",
              onSelected: (locale) => widget.onLocaleChanged(locale),
              itemBuilder: (context) => supportedLocales
                  .map((locale) => PopupMenuItem<Locale>(
                        value: locale,
                        child: Row(
                          children: [
                            const Icon(Icons.language),
                            const SizedBox(width: 8),
                            Text(languageNames[locale.languageCode] ?? locale.languageCode)
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: theme.accentYellow,
          unselectedItemColor: theme.textFaint,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learning'),
            BottomNavigationBarItem(icon: Icon(Icons.self_improvement), label: 'Well-being'),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_emotions), label: 'Jokes'),
            BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Sleep Sounds'), // <-- ADD THIS
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
