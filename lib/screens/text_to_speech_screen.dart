import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import '../theme_colors.dart';
import '../utils/lang_detect.dart';

// Add your supported locales and translations here.
const supportedLocales = [
  Locale('en', 'US'),
  Locale('ja', 'JP'),
  Locale('bn', 'BD'),
  Locale('es', 'ES'),
  Locale('fr', 'FR'),
  Locale('ar', 'EG'),
  Locale('zh', 'CN'),
];

// Localized strings for UI, mapped by language code
const localizedStrings = {
  'en': {
    'title': 'Text to Speech',
    'save': 'Save',
    'export': 'Export as audio file',
    'share': 'Share text to...',
    'find': 'Find',
    'tools': 'Tools',
    'text_style': 'Text style',
    'drawer_title': 'Text to Speech',
    'new_file': 'New file',
    'open_file': 'Open file',
    'recent_files': 'Recent Files',
    'browser': 'Browser',
    'type_speak': 'Type speak',
    'settings': 'Settings',
    'about': 'About',
    'upgrade': 'Pro version upgrade',
    'detected_language': 'Detected language',
    'translating': 'Translating...',
    'listen_translation': 'Listen',
    'hint': 'Paste or type your text here...',
    'translation': 'Translation',
    'speak_original': 'Speak Original',
    'translation_failed': 'Translation failed. Please check your internet connection.',
    'voice': 'Voice',
    'speed': 'Speed',
    'pitch': 'Pitch',
  },
  'ja': {
    'title': 'テキスト読み上げ',
    'save': '保存',
    'export': '音声ファイルとしてエクスポート',
    'share': 'テキストを共有...',
    'find': '検索',
    'tools': 'ツール',
    'text_style': 'テキストスタイル',
    'drawer_title': 'テキスト読み上げ',
    'new_file': '新規ファイル',
    'open_file': 'ファイルを開く',
    'recent_files': '最近のファイル',
    'browser': 'ブラウザ',
    'type_speak': 'タイプ読み上げ',
    'settings': '設定',
    'about': '情報',
    'upgrade': 'Proバージョンアップグレード',
    'detected_language': '検出された言語',
    'translating': '翻訳中...',
    'listen_translation': '翻訳を聞く',
    'hint': 'ここにテキストを入力または貼り付けてください...',
    'translation': '翻訳',
    'speak_original': '元のテキストを話す',
    'translation_failed': '翻訳に失敗しました。インターネット接続を確認してください。',
    'voice': 'ボイス',
    'speed': 'スピード',
    'pitch': 'ピッチ',
  },
  'bn': {
    'title': 'টেক্সট টু স্পিচ',
    'save': 'সংরক্ষণ করুন',
    'export': 'অডিও ফাইল হিসেবে রপ্তানি করুন',
    'share': 'টেক্সট শেয়ার করুন...',
    'find': 'খুঁজুন',
    'tools': 'টুলস',
    'text_style': 'টেক্সট স্টাইল',
    'drawer_title': 'টেক্সট টু স্পিচ',
    'new_file': 'নতুন ফাইল',
    'open_file': 'ফাইল খুলুন',
    'recent_files': 'সাম্প্রতিক ফাইল',
    'browser': 'ব্রাউজার',
    'type_speak': 'টাইপ স্পিক',
    'settings': 'সেটিংস',
    'about': 'সম্পর্কে',
    'upgrade': 'প্রো ভার্সন আপগ্রেড',
    'detected_language': 'সনাক্তকৃত ভাষা',
    'translating': 'অনুবাদ হচ্ছে...',
    'listen_translation': 'অনুবাদ শুনুন',
    'hint': 'এখানে লিখুন অথবা পেস্ট করুন...',
    'translation': 'অনুবাদ',
    'speak_original': 'মূল পাঠ বলুন',
    'translation_failed': 'অনুবাদ ব্যর্থ হয়েছে। আপনার ইন্টারনেট সংযোগ পরীক্ষা করুন।',
    'voice': 'ভয়েস',
    'speed': 'গতি',
    'pitch': 'পিচ',
  },
  'es': {
    'title': 'Texto a voz',
    'save': 'Guardar',
    'export': 'Exportar como archivo de audio',
    'share': 'Compartir texto...',
    'find': 'Buscar',
    'tools': 'Herramientas',
    'text_style': 'Estilo de texto',
    'drawer_title': 'Texto a voz',
    'new_file': 'Nuevo archivo',
    'open_file': 'Abrir archivo',
    'recent_files': 'Archivos recientes',
    'browser': 'Navegador',
    'type_speak': 'Escribir para hablar',
    'settings': 'Configuraciones',
    'about': 'Acerca de',
    'upgrade': 'Actualizar a Pro',
    'detected_language': 'Idioma detectado',
    'translating': 'Traduciendo...',
    'listen_translation': 'Escuchar traducción',
    'hint': 'Pega o escribe tu texto aquí...',
    'translation': 'Traducción',
    'speak_original': 'Hablar original',
    'translation_failed': 'La traducción falló. Verifique su conexión a Internet.',
    'voice': 'Voz',
    'speed': 'Velocidad',
    'pitch': 'Tono',
  },
  'fr': {
    'title': 'Texte en parole',
    'save': 'Enregistrer',
    'export': 'Exporter en fichier audio',
    'share': 'Partager le texte...',
    'find': 'Trouver',
    'tools': 'Outils',
    'text_style': 'Style de texte',
    'drawer_title': 'Texte en parole',
    'new_file': 'Nouveau fichier',
    'open_file': 'Ouvrir le fichier',
    'recent_files': 'Fichiers récents',
    'browser': 'Navigateur',
    'type_speak': 'Saisie vocale',
    'settings': 'Paramètres',
    'about': 'À propos',
    'upgrade': 'Version Pro',
    'detected_language': 'Langue détectée',
    'translating': 'Traduction...',
    'listen_translation': 'Écouter la traduction',
    'hint': 'Collez ou tapez votre texte ici...',
    'translation': 'Traduction',
    'speak_original': 'Parler original',
    'translation_failed': 'Échec de la traduction. Vérifiez votre connexion Internet.',
    'voice': 'Voix',
    'speed': 'Vitesse',
    'pitch': 'Tonalité',
  },
  'ar': {
    'title': 'تحويل النص إلى كلام',
    'save': 'حفظ',
    'export': 'تصدير كملف صوتي',
    'share': 'مشاركة النص...',
    'find': 'بحث',
    'tools': 'أدوات',
    'text_style': 'نمط النص',
    'drawer_title': 'تحويل النص إلى كلام',
    'new_file': 'ملف جديد',
    'open_file': 'فتح ملف',
    'recent_files': 'الملفات الأخيرة',
    'browser': 'المتصفح',
    'type_speak': 'كتابة للنطق',
    'settings': 'الإعدادات',
    'about': 'حول',
    'upgrade': 'ترقية النسخة الاحترافية',
    'detected_language': 'اللغة المكتشفة',
    'translating': 'جاري الترجمة...',
    'listen_translation': 'استمع للترجمة',
    'hint': 'الصق أو اكتب نصك هنا...',
    'translation': 'الترجمة',
    'speak_original': 'النطق الأصلي',
    'translation_failed': 'فشل الترجمة. يرجى التحقق من اتصال الإنترنت.',
    'voice': 'الصوت',
    'speed': 'السرعة',
    'pitch': 'حدة الصوت',
  },
  'zh': {
    'title': '文本转语音',
    'save': '保存',
    'export': '导出为音频文件',
    'share': '分享文本...',
    'find': '查找',
    'tools': '工具',
    'text_style': '文本样式',
    'drawer_title': '文本转语音',
    'new_file': '新建文件',
    'open_file': '打开文件',
    'recent_files': '最近的文件',
    'browser': '浏览器',
    'type_speak': '输入朗读',
    'settings': '设置',
    'about': '关于',
    'upgrade': '专业版升级',
    'detected_language': '检测到的语言',
    'translating': '正在翻译...',
    'listen_translation': '听翻译',
    'hint': '在此粘贴或输入文本...',
    'translation': '翻译',
    'speak_original': '朗读原文',
    'translation_failed': '翻译失败。请检查您的网络连接。',
    'voice': '语音',
    'speed': '语速',
    'pitch': '音调',
  },
};

String getLang(BuildContext context, String key, Locale locale) {
  final code = locale.languageCode;
  if (localizedStrings.containsKey(code) &&
      localizedStrings[code]!.containsKey(key)) {
    return localizedStrings[code]![key]!;
  }
  if (localizedStrings['en'] != null && localizedStrings['en']!.containsKey(key)) {
    return localizedStrings['en']![key]!;
  }
  return key;
}

const Map<String, String> languageMap = {
  'English': 'en',
  'Japanese': 'ja',
  'Bangla': 'bn',
  'Spanish': 'es',
  'French': 'fr',
  'Arabic': 'ar',
  'Chinese': 'zh',
};

class TextToSpeechScreen extends StatefulWidget {
  final RiseiTheme riseiTheme;
  final Locale locale;
  const TextToSpeechScreen({Key? key, required this.riseiTheme, required this.locale}) : super(key: key);

  @override
  State<TextToSpeechScreen> createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final TextEditingController _controller = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  final GoogleTranslator _translator = GoogleTranslator();

  String? _detectedLangCode = 'en';
  String? _translatedText;
  String? _selectedLangCode = 'en';
  bool _isTranslating = false;

  // Voice/pitch/speed
  Map<String, List<dynamic>> _voicesByLang = {};
  Map<String, String?> _selectedVoiceByLang = {};
  double _speechSpeed = 0.5; // 0.0~1.0 (default .5)
  double _speechPitch = 1.0; // 0.5~2.0 (default 1.0)

  String _mapLangCodeForTTS(String code) {
    switch (code) {
      case 'en': return 'en-US';
      case 'ja': return 'ja-JP';
      case 'bn': return 'bn-BD';
      case 'es': return 'es-ES';
      case 'fr': return 'fr-FR';
      case 'ar': return 'ar-SA';
      case 'zh': return 'zh-CN';
      default: return code;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _initVoices();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _updateDetectedLanguage();
    _autoTranslate();
  }

  void _updateDetectedLanguage() {
    setState(() {
      if (_controller.text.trim().isNotEmpty) {
        _detectedLangCode = SimpleLangDetect.detect(_controller.text);
      } else {
        _detectedLangCode = '-';
      }
    });
  }

  Future<void> _initVoices() async {
    final voices = await _flutterTts.getVoices;
    Map<String, List<dynamic>> byLang = {};
    for (var voice in voices) {
      if (voice is Map && voice['locale'] != null) {
        String lang = (voice['locale'] as String).split('-').first;
        byLang.putIfAbsent(lang, () => []).add(voice);
      }
    }
    setState(() {
      _voicesByLang = byLang;
      for (final entry in languageMap.values) {
        if (_voicesByLang[entry] != null && _voicesByLang[entry]!.isNotEmpty) {
          _selectedVoiceByLang[entry] = _voicesByLang[entry]!.first['name'];
        } else {
          _selectedVoiceByLang[entry] = null;
        }
      }
    });
  }

  Future<void> _autoTranslate() async {
    String text = _controller.text.trim();
    if (text.isEmpty || _selectedLangCode == null) {
      setState(() => _translatedText = null);
      return;
    }
    setState(() {
      _isTranslating = true;
      _translatedText = null;
    });
    try {
      final result = await _translator.translate(text, to: _selectedLangCode!);
      setState(() {
        _translatedText = result.text;
        _isTranslating = false;
      });
    } catch (e) {
      setState(() {
        _translatedText = getLang(context, 'translation_failed', widget.locale);
        _isTranslating = false;
      });
    }
  }

  Future<void> _speak([String? customText, String? langCode]) async {
    String text = customText ?? _controller.text.trim();
    if (text.isEmpty) return;

    final lang = langCode ?? _detectedLangCode ?? 'en';
    final ttsLang = _mapLangCodeForTTS(lang);

    try {
      await _flutterTts.setLanguage(ttsLang);
      await _flutterTts.setSpeechRate(_speechSpeed);
      await _flutterTts.setPitch(_speechPitch);
      final selectedVoice = _selectedVoiceByLang[lang];
      if (selectedVoice != null) {
        await _flutterTts.setVoice({"name": selectedVoice, "locale": ttsLang});
      }
      await _flutterTts.speak(text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('TTS failed: $e')),
      );
    }
  }

  Future<void> _onLanguageChanged(String? newLangCode) async {
    setState(() {
      _selectedLangCode = newLangCode;
      final voices = _voicesByLang[_selectedLangCode ?? 'en'] ?? [];
      if (voices.isNotEmpty) {
        final currentVoice = _selectedVoiceByLang[_selectedLangCode ?? 'en'];
        if (currentVoice == null || !voices.any((v) => v['name'] == currentVoice)) {
          _selectedVoiceByLang[_selectedLangCode ?? 'en'] = voices.first['name'];
        }
      } else {
        _selectedVoiceByLang[_selectedLangCode ?? 'en'] = null;
      }
    });
    await _autoTranslate();
  }

  Future<void> _translateAndSpeak() async {
    await _autoTranslate();
    if (_translatedText == null ||
        _translatedText!.isEmpty ||
        _translatedText == getLang(context, 'translation_failed', widget.locale)) {
      return;
    }
    await _speak(_translatedText, _selectedLangCode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.riseiTheme;
    final Color backgroundColor = theme.backgroundGradient.colors.first;
    final Locale locale = widget.locale;
    final langVoices = _voicesByLang[_selectedLangCode ?? 'en'] ?? [];
    String? selectedVoice = _selectedVoiceByLang[_selectedLangCode ?? 'en'];

      // --- FIX: Ensure selectedVoice is valid for DropdownButton ---
    bool selectedVoiceIsValid = selectedVoice != null &&
        langVoices.any((v) => v['name'] == selectedVoice);

    // If not valid, set to null so DropdownButton doesn't get an invalid value
    if (!selectedVoiceIsValid) selectedVoice = null;
    // ------------------------------------------------------------

    Widget voiceWidget;
    if (langVoices.isNotEmpty && selectedVoice != null) {
      voiceWidget = Expanded(
        child: DropdownButton<String>(
          dropdownColor: Colors.grey[900],
          value: selectedVoice,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: langVoices.map<DropdownMenuItem<String>>((voice) {
            String showName = voice['name'] ?? '';
            String gender = (voice['gender'] ?? '').toString();
            return DropdownMenuItem<String>(
              value: voice['name'],
              child: Text(
                showName.isNotEmpty && gender.isNotEmpty
                    ? '$showName ($gender)'
                    : showName,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (voiceName) {
            setState(() {
              _selectedVoiceByLang[_selectedLangCode ?? 'en'] = voiceName;
            });
          },
          hint: Text(getLang(context, 'voice', locale), style: const TextStyle(color: Colors.white)),
        ),
      );
    } else {
      final langName = languageMap.entries.firstWhere(
        (e) => e.value == (_selectedLangCode ?? 'en'),
        orElse: () => const MapEntry('English', 'en'),
      ).key;
      voiceWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Text(
          langName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(getLang(context, 'title', locale)),
        backgroundColor: theme.backgroundGradient.colors[1],
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              PopupMenuItem(value: 'save', child: Text(getLang(context, 'save', locale))),
              PopupMenuItem(value: 'export', child: Text(getLang(context, 'export', locale))),
              PopupMenuItem(value: 'share', child: Text(getLang(context, 'share', locale))),
              PopupMenuItem(value: 'find', child: Text(getLang(context, 'find', locale))),
              PopupMenuItem(value: 'tools', child: Text(getLang(context, 'tools', locale))),
              PopupMenuItem(value: 'text_style', child: Text(getLang(context, 'text_style', locale))),
            ],
            onSelected: (value) {
              // TODO: Implement menu actions
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text(getLang(context, 'drawer_title', locale))),
            ListTile(
                leading: const Icon(Icons.note_add),
                title: Text(getLang(context, 'new_file', locale)),
                onTap: () {}),
            ListTile(
                leading: const Icon(Icons.folder_open),
                title: Text(getLang(context, 'open_file', locale)),
                onTap: () {}),
            ListTile(
                leading: const Icon(Icons.history),
                title: Text(getLang(context, 'recent_files', locale)),
                onTap: () {}),
            ListTile(
                leading: const Icon(Icons.language),
                title: Text(getLang(context, 'browser', locale)),
                onTap: () {}),
            ListTile(
                leading: const Icon(Icons.keyboard),
                title: Text(getLang(context, 'type_speak', locale)),
                onTap: () {}),
            ListTile(
                leading: const Icon(Icons.settings),
                title: Text(getLang(context, 'settings', locale)),
                onTap: () {}),
            ListTile(
                leading: const Icon(Icons.info),
                title: Text(getLang(context, 'about', locale)),
                onTap: () {}),
            ListTile(
                leading: const Icon(Icons.upgrade),
                title: Text(getLang(context, 'upgrade', locale)),
                onTap: () {}),
          ],
        ),
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_controller.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "${getLang(context, 'detected_language', locale)}: $_detectedLangCode",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.grey[900],
                    value: _selectedLangCode,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: languageMap.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.value,
                        child: Text(entry.key,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) => _onLanguageChanged(value),
                  ),
                ),
                if (langVoices.isNotEmpty || selectedVoice == null)
                  const SizedBox(width: 12),
                voiceWidget,
                ElevatedButton.icon(
                  icon: _isTranslating
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.translate),
                  label: Text(
                      _isTranslating ? getLang(context, 'translating', locale) : getLang(context, 'listen_translation', locale)),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _isTranslating ? null : _translateAndSpeak,
                ),
              ],
            ),
            // Speech rate and pitch sliders
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getLang(context, 'speed', locale),
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Slider(
                        value: _speechSpeed,
                        min: 0.1,
                        max: 1.0,
                        divisions: 9,
                        label: _speechSpeed.toStringAsFixed(2),
                        onChanged: (v) {
                          setState(() {
                            _speechSpeed = v;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getLang(context, 'pitch', locale),
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Slider(
                        value: _speechPitch,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        label: _speechPitch.toStringAsFixed(2),
                        onChanged: (v) {
                          setState(() {
                            _speechPitch = v;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: getLang(context, 'hint', locale),
                  hintStyle: const TextStyle(color: Colors.white54),
                ),
              ),
            ),
            if (_translatedText != null && _translatedText!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Card(
                  color: Colors.grey[900],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "${getLang(context, 'translation', locale)}: $_translatedText",
                      style: const TextStyle(
                          color: Colors.lightGreenAccent, fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.play_arrow),
        onPressed: () => _speak(),
        tooltip: getLang(context, 'speak_original', locale),
      ),
    );
  }
}
