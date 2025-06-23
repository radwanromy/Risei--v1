import 'package:flutter/material.dart';
import 'theme_colors.dart';
import 'screens/learning_screen.dart';
import 'screens/wellbeing_screen.dart';
import 'screens/joke_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/sleep_sounds_screen.dart';
import 'screens/text_to_speech_screen.dart';
import 'screens/learning_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Supported locales
const List<Locale> supportedLocales = [
  Locale('en', 'US'),
  Locale('ja', 'JP'),
  Locale('bn', 'BD'),
  Locale('es', 'ES'),
  Locale('fr', 'FR'),
  Locale('ar', 'EG'),
  Locale('zh', 'CN'),
];

// Menu titles and labels per language
const localizedMenu = {
  'en': {
    'tasks': 'Tasks',
    'learning': 'Learning',
    'wellbeing': 'Well-being',
    'jokes': 'Jokes',
    'sleep': 'Sleep Sounds',
    'tts': 'Text to Speech',
    'toggle_theme': 'Toggle Theme',
    'change_theme': 'Change App Theme',
    'change_language': 'Change Language',
    'purple_cyan': 'Purple Cyan',
    'orange_pink': 'Orange Pink',
    'blue_green': 'Blue Green',
    'red_amber': 'Red Amber',
    'solid_black': 'Solid Black',
    'solid_white': 'Solid White',
  },
  'ja': {
    'tasks': 'タスク',
    'learning': '学習',
    'wellbeing': '健康',
    'jokes': 'ジョーク',
    'sleep': '睡眠サウンド',
    'tts': 'テキスト読み上げ',
    'toggle_theme': 'テーマ切替',
    'change_theme': 'テーマ変更',
    'change_language': '言語を変更',
    'purple_cyan': 'パープルシアン',
    'orange_pink': 'オレンジピンク',
    'blue_green': 'ブルーグリーン',
    'red_amber': 'レッドアンバー',
    'solid_black': 'ソリッドブラック',
    'solid_white': 'ソリッドホワイト',
  },
  'bn': {
    'tasks': 'টাস্ক',
    'learning': 'শেখা',
    'wellbeing': 'মঙ্গল',
    'jokes': 'কৌতুক',
    'sleep': 'ঘুমের সুর',
    'tts': 'টেক্সট টু স্পিচ',
    'toggle_theme': 'থিম পরিবর্তন',
    'change_theme': 'থিম পরিবর্তন করুন',
    'change_language': 'ভাষা পরিবর্তন করুন',
    'purple_cyan': 'পার্পল সায়ান',
    'orange_pink': 'কমলা গোলাপী',
    'blue_green': 'নীল সবুজ',
    'red_amber': 'লাল অ্যাম্বার',
    'solid_black': 'সলিড ব্ল্যাক',
    'solid_white': 'সলিড হোয়াইট',
  },
  'es': {
    'tasks': 'Tareas',
    'learning': 'Aprendizaje',
    'wellbeing': 'Bienestar',
    'jokes': 'Bromas',
    'sleep': 'Sonidos para Dormir',
    'tts': 'Texto a Voz',
    'toggle_theme': 'Cambiar Tema',
    'change_theme': 'Cambiar Tema de la App',
    'change_language': 'Cambiar Idioma',
    'purple_cyan': 'Púrpura Cian',
    'orange_pink': 'Naranja Rosa',
    'blue_green': 'Azul Verde',
    'red_amber': 'Rojo Ámbar',
    'solid_black': 'Negro Sólido',
    'solid_white': 'Blanco Sólido',
  },
  'fr': {
    'tasks': 'Tâches',
    'learning': 'Apprentissage',
    'wellbeing': 'Bien-être',
    'jokes': 'Blagues',
    'sleep': 'Sons pour Dormir',
    'tts': 'Texte en Parole',
    'toggle_theme': 'Changer le Thème',
    'change_theme': 'Changer le Thème de l\'App',
    'change_language': 'Changer de Langue',
    'purple_cyan': 'Violet Cyan',
    'orange_pink': 'Orange Rose',
    'blue_green': 'Bleu Vert',
    'red_amber': 'Rouge Ambre',
    'solid_black': 'Noir Uni',
    'solid_white': 'Blanc Uni',
  },
  'ar': {
    'tasks': 'المهام',
    'learning': 'التعلم',
    'wellbeing': 'الرفاهية',
    'jokes': 'نكت',
    'sleep': 'أصوات النوم',
    'tts': 'تحويل النص إلى كلام',
    'toggle_theme': 'تبديل السمة',
    'change_theme': 'تغيير سمة التطبيق',
    'change_language': 'تغيير اللغة',
    'purple_cyan': 'أرجواني سماوي',
    'orange_pink': 'برتقالي وردي',
    'blue_green': 'أزرق أخضر',
    'red_amber': 'أحمر كهرماني',
    'solid_black': 'أسود صلب',
    'solid_white': 'أبيض صلب',
  },
  'zh': {
    'tasks': '任务',
    'learning': '学习',
    'wellbeing': '健康',
    'jokes': '笑话',
    'sleep': '助眠音',
    'tts': '文字转语音',
    'toggle_theme': '切换主题',
    'change_theme': '更改应用主题',
    'change_language': '更改语言',
    'purple_cyan': '紫色青色',
    'orange_pink': '橙色粉色',
    'blue_green': '蓝绿色',
    'red_amber': '红琥珀色',
    'solid_black': '纯黑',
    'solid_white': '纯白',
  },
};

// Language display names for the picker
const Map<String, String> languageNames = {
  'en': 'English',
  'ja': '日本語',
  'bn': 'বাংলা',
  'es': 'Español',
  'fr': 'Français',
  'ar': 'العربية',
  'zh': '中文',
};


String getLocaleCode(Locale locale) => locale.languageCode.toLowerCase();

String t(Locale locale, String key) {
  final langCode = getLocaleCode(locale);
  return localizedMenu[langCode]?[key] ??
      localizedMenu['en']![key] ??
      key;
}

class MenuEntry {
  final String key;
  final IconData icon;
  final Widget Function() screenBuilder;
  MenuEntry({required this.key, required this.icon, required this.screenBuilder});
}

// For saving/loading order
const String _menuOrderPrefsKey = 'main_menu_order_v1';

class MainNavigation extends StatefulWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) onThemeModeChanged;
  final MaterialColor primarySwatch;
  final void Function(MaterialColor) onSwatchChanged;
  final Locale locale;
  final void Function(Locale) onLocaleChanged;
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
  late List<MenuEntry> _menuEntries;
  bool _loadingMenuOrder = true;

  // Default order
  List<MenuEntry> _defaultMenuEntries() => [
        MenuEntry(
          key: 'tasks',
          icon: Icons.task,
          screenBuilder: () => TasksScreen(
            themeMode: widget.themeMode,
            onThemeModeChanged: widget.onThemeModeChanged,
            primarySwatch: widget.primarySwatch,
            onSwatchChanged: widget.onSwatchChanged,
            locale: widget.locale,
            onLocaleChanged: widget.onLocaleChanged,
            riseiTheme: widget.riseiTheme,
          ),
        ),
        MenuEntry(
          key: 'learning',
          icon: Icons.school,
          screenBuilder: () => LearningScreen(riseiTheme: widget.riseiTheme),
        ),
        MenuEntry(
          key: 'wellbeing',
          icon: Icons.self_improvement,
          screenBuilder: () => const WellbeingScreen(),
        ),
        MenuEntry(
          key: 'jokes',
          icon: Icons.emoji_emotions,
          screenBuilder: () => const JokeScreen(),
        ),
        MenuEntry(
          key: 'sleep',
          icon: Icons.music_note,
          screenBuilder: () => SleepSoundsScreen(
            riseiTheme: widget.riseiTheme,
            locale: widget.locale,
          ),
        ),
        MenuEntry(
          key: 'tts',
          icon: Icons.record_voice_over,
          screenBuilder: () => TextToSpeechScreen(
            riseiTheme: widget.riseiTheme,
            locale: widget.locale,
          ),
        ),
      ];

  // For menu key lookup
  late Map<String, MenuEntry> _entryMap;

  @override
  void initState() {
    super.initState();
    final defaultEntries = _defaultMenuEntries();
    _entryMap = {for (var entry in defaultEntries) entry.key: entry};
    _menuEntries = defaultEntries;
    _loadMenuOrder();
  }

  void _loadMenuOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOrder = prefs.getStringList(_menuOrderPrefsKey);
    if (savedOrder != null && savedOrder.isNotEmpty) {
      // Only keep entries that are present in the current version
      final entries = [
        for (final key in savedOrder)
          if (_entryMap.containsKey(key)) _entryMap[key]!
      ];
      // Add any missing new entries at the end
      final missing = _entryMap.keys.where((k) => !savedOrder.contains(k));
      for (final k in missing) {
        entries.add(_entryMap[k]!);
      }
      setState(() {
        _menuEntries = entries;
        _loadingMenuOrder = false;
      });
    } else {
      setState(() {
        _menuEntries = _defaultMenuEntries();
        _loadingMenuOrder = false;
      });
    }
  }

  // Save order to prefs
  void _saveMenuOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _menuOrderPrefsKey, _menuEntries.map((e) => e.key).toList());
  }

  void _showReorderMenuDialog() async {
    List<MenuEntry> tempOrder = List.from(_menuEntries);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reorder Menu'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = tempOrder.removeAt(oldIndex);
              tempOrder.insert(newIndex, item);
            },
            children: [
              for (final entry in tempOrder)
                ListTile(
                  key: ValueKey(entry.key),
                  leading: Icon(entry.icon),
                  title: Text(t(widget.locale, entry.key)),
                  trailing: const Icon(Icons.drag_handle),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // cancel
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _menuEntries = List.from(tempOrder);
                if (_currentIndex >= _menuEntries.length) _currentIndex = 0;
              });
              _saveMenuOrder();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.riseiTheme;
    final locale = widget.locale;
    if (_loadingMenuOrder) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentMenu = _menuEntries[_currentIndex];

    return Container(
      decoration: BoxDecoration(
        gradient: theme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            t(locale, currentMenu.key),
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
              tooltip: t(locale, 'toggle_theme'),
              onPressed: () {
                widget.onThemeModeChanged(
                  widget.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              tooltip: 'Reorder Menu',
              onPressed: _showReorderMenuDialog,
            ),
            PopupMenuButton<RiseiTheme>(
              icon: Icon(Icons.palette, color: theme.accentYellow),
              tooltip: t(locale, 'change_theme'),
              onSelected: widget.onThemeChanged,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: purpleCyanTheme,
                  child: Text(t(locale, 'purple_cyan')),
                ),
                PopupMenuItem(
                  value: orangePinkTheme,
                  child: Text(t(locale, 'orange_pink')),
                ),
                PopupMenuItem(
                  value: blueGreenTheme,
                  child: Text(t(locale, 'blue_green')),
                ),
                PopupMenuItem(
                  value: redAmberTheme,
                  child: Text(t(locale, 'red_amber')),
                ),
                PopupMenuItem(
                  value: solidBlackTheme,
                  child: Text(t(locale, 'solid_black')),
                ),
                PopupMenuItem(
                  value: solidWhiteTheme,
                  child: Text(t(locale, 'solid_white')),
                ),
              ],
            ),
            PopupMenuButton<Locale>(
              icon: Icon(Icons.language, color: theme.accentYellow),
              tooltip: t(locale, 'change_language'),
              onSelected: widget.onLocaleChanged,
              itemBuilder: (context) => supportedLocales
                  .map((l) => PopupMenuItem<Locale>(
                        value: l,
                        child: Row(
                          children: [
                            const Icon(Icons.language),
                            const SizedBox(width: 8),
                            Text(languageNames[l.languageCode] ?? l.languageCode)
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text(
                  t(locale, _menuEntries[0].key),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              for (int i = 0; i < _menuEntries.length; i++)
                ListTile(
                  leading: Icon(_menuEntries[i].icon),
                  title: Text(t(locale, _menuEntries[i].key)),
                  selected: _currentIndex == i,
                  onTap: () {
                    setState(() => _currentIndex = i);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
        body: _menuEntries[_currentIndex].screenBuilder(),
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
          items: _menuEntries
              .map((entry) => BottomNavigationBarItem(
                    icon: Icon(entry.icon),
                    label: t(locale, entry.key),
                  ))
              .toList(),
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
