import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_tts/flutter_tts.dart'; // <-- ADD THIS LINE
import 'learning_screen.dart';
import 'wellbeing_screen.dart';
import 'joke_screen.dart';
import 'theme_colors.dart';

// Add supported languages and display names for the language picker.
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

// Add translations for UI strings (now including Español, Français, العربية, 中文)
const Map<String, Map<String, String>> localizedStrings = {
  'add_task': {
    'en': 'Add Task',
    'ja': 'タスクを追加',
    'bn': 'টাস্ক যোগ করুন',
    'es': 'Agregar tarea',
    'fr': 'Ajouter une tâche',
    'ar': 'إضافة مهمة',
    'zh': '添加任务',
  },
  'edit_task': {
    'en': 'Edit Task',
    'ja': 'タスクを編集',
    'bn': 'টাস্ক সম্পাদনা করুন',
    'es': 'Editar tarea',
    'fr': 'Modifier la tâche',
    'ar': 'تعديل المهمة',
    'zh': '编辑任务',
  },
  'task_name': {
    'en': 'Task Name',
    'ja': 'タスク名',
    'bn': 'টাস্কের নাম',
    'es': 'Nombre de la tarea',
    'fr': 'Nom de la tâche',
    'ar': 'اسم المهمة',
    'zh': '任务名称',
  },
  'description': {
    'en': 'Description',
    'ja': '説明',
    'bn': 'বর্ণনা',
    'es': 'Descripción',
    'fr': 'Description',
    'ar': 'الوصف',
    'zh': '描述',
  },
  'due_date': {
    'en': 'Due Date',
    'ja': '期日',
    'bn': 'সময়সীমা',
    'es': 'Fecha de vencimiento',
    'fr': 'Date d\'échéance',
    'ar': 'تاريخ الاستحقاق',
    'zh': '截止日期',
  },
  'not_selected': {
    'en': 'Not selected',
    'ja': '未選択',
    'bn': 'নির্বাচিত নয়',
    'es': 'No seleccionado',
    'fr': 'Non sélectionné',
    'ar': 'لم يتم التحديد',
    'zh': '未选择',
  },
  'priority': {
    'en': 'Priority',
    'ja': '優先度',
    'bn': 'অগ্রাধিকার',
    'es': 'Prioridad',
    'fr': 'Priorité',
    'ar': 'الأولوية',
    'zh': '优先级',
  },
  'add_attachment': {
    'en': 'Add Attachment',
    'ja': '添付ファイルを追加',
    'bn': 'সংযুক্তি যোগ করুন',
    'es': 'Agregar archivo adjunto',
    'fr': 'Ajouter une pièce jointe',
    'ar': 'إضافة مرفق',
    'zh': '添加附件',
  },
  'set_reminder': {
    'en': 'Set Reminder',
    'ja': 'リマインダーを設定',
    'bn': 'রিমাইন্ডার সেট করুন',
    'es': 'Establecer recordatorio',
    'fr': 'Définir un rappel',
    'ar': 'تعيين تذكير',
    'zh': '设置提醒',
  },
  'cancel': {
    'en': 'Cancel',
    'ja': 'キャンセル',
    'bn': 'বাতিল',
    'es': 'Cancelar',
    'fr': 'Annuler',
    'ar': 'إلغاء',
    'zh': '取消',
  },
  'add': {
    'en': 'Add',
    'ja': '追加',
    'bn': 'যোগ করুন',
    'es': 'Agregar',
    'fr': 'Ajouter',
    'ar': 'إضافة',
    'zh': '添加',
  },
  'save': {
    'en': 'Save',
    'ja': '保存',
    'bn': 'সংরক্ষণ করুন',
    'es': 'Guardar',
    'fr': 'Enregistrer',
    'ar': 'حفظ',
    'zh': '保存',
  },
  'no_tasks': {
    'en': 'No tasks yet.',
    'ja': 'まだタスクがありません。',
    'bn': 'এখনও কোনো টাস্ক নেই।',
    'es': 'No hay tareas todavía.',
    'fr': 'Aucune tâche pour le moment.',
    'ar': 'لا توجد مهام بعد.',
    'zh': '还没有任务。',
  },
  'tasks': {
    'en': 'Tasks',
    'ja': 'タスク',
    'bn': 'টাস্ক',
    'es': 'Tareas',
    'fr': 'Tâches',
    'ar': 'المهام',
    'zh': '任务',
  },
  'learning': {
    'en': 'Learning',
    'ja': '学習',
    'bn': 'শিক্ষা',
    'es': 'Aprendizaje',
    'fr': 'Apprentissage',
    'ar': 'التعلم',
    'zh': '学习',
  },
  'wellbeing': {
    'en': 'Well-being',
    'ja': '健康',
    'bn': 'কল্যাণ',
    'es': 'Bienestar',
    'fr': 'Bien-être',
    'ar': 'العافية',
    'zh': '健康',
  },
  'jokes': {
    'en': 'Jokes',
    'ja': 'ジョーク',
    'bn': 'কৌতুক',
    'es': 'Bromas',
    'fr': 'Blagues',
    'ar': 'نكات',
    'zh': '笑话',
  },
  'reminder': {
    'en': 'Reminder',
    'ja': 'リマインダー',
    'bn': 'রিমাইন্ডার',
    'es': 'Recordatorio',
    'fr': 'Rappel',
    'ar': 'تذكير',
    'zh': '提醒',
  },
  'file': {
    'en': 'file(s)',
    'ja': 'ファイル',
    'bn': 'ফাইল',
    'es': 'archivo(s)',
    'fr': 'fichier(s)',
    'ar': 'ملف(ات)',
    'zh': '文件',
  },
  'menu': {
    'en': 'Menu',
    'ja': 'メニュー',
    'bn': 'মেনু',
    'es': 'Menú',
    'fr': 'Menu',
    'ar': 'القائمة',
    'zh': '菜单',
  },
};

// Add translations for motivational quotes.
const Map<String, List<String>> localizedQuotes = {
  'en': [
    "Indeed, Allah loves those who rely upon Him. — Quran (3:159)",
    "Verily, with hardship comes ease. — Quran (94:6)",
    "The best of people are those that bring most benefit to mankind. — Prophet Muhammad (peace be upon him)",
    "The secret of getting ahead is getting started. — Mark Twain",
    "Success is the sum of small efforts, repeated day in and day out. — Robert Collier",
    "The future depends on what you do today. — Mahatma Gandhi",
    "Discipline is the bridge between goals and accomplishment. — Jim Rohn",
    "Don’t watch the clock; do what it does. Keep going. — Sam Levenson",
    "Productivity is never an accident. It is always the result of a commitment to excellence, planning, and focused effort. — Paul J. Meyer",
    "A goal without a plan is just a wish. — Antoine de Saint-Exupéry"
  ],
  'ja': [
    "本当に、アッラーは彼に信頼する者を愛する。— クルアーン (3:159)",
    "本当に、困難の後には安堵がある。— クルアーン (94:6)",
    "人々の中で最良なのは、人類に最も利益をもたらす者である。— 預言者ムハンマド（彼に平安あれ）",
    "前進する秘訣は始めることだ。— マーク・トウェイン",
    "成功は、小さな努力が日々繰り返されることの積み重ねである。— ロバート・コリアー",
    "未来は今日あなたが何をするかにかかっている。— マハトマ・ガンジー",
    "規律は目標と達成をつなぐ橋である。— ジム・ローン",
    "時計を見るな。時計がすることをせよ。進み続けよ。— サム・レベンソン",
    "生産性は決して偶然ではない。それは常に卓越性、計画、集中した努力の結果である。— ポール・J・マイヤー",
    "計画のない目標は、ただの願いにすぎない。— アントワーヌ・ド・サン＝テグジュペリ"
  ],
  'bn': [
    "নিশ্চয়ই, আল্লাহ তাদের ভালোবাসেন যারা তাঁর ওপর নির্ভর করে। — কুরআন (৩:১৫৯)",
    "নিশ্চয়ই, কষ্টের সাথে সহজতাও রয়েছে। — কুরআন (৯৪:৬)",
    "সর্বোত্তম মানুষ সে, যে মানুষের উপকারে আসে। — মহানবী মুহাম্মদ (সা.)",
    "সফলতার গোপন কথা শুরু করা। — মার্ক টোয়েন",
    "সফলতা হল ছোট ছোট প্রচেষ্টার যোগফল, প্রতিদিন এবং প্রতিনিয়ত। — রবার্ট কলিয়ার",
    "ভবিষ্যত নির্ভর করে আজ তুমি কী করছো তার উপর। — মহাত্মা গান্ধী",
    "শৃঙ্খলা হল লক্ষ্য ও অর্জনের মধ্যে সেতুবন্ধন। — জিম রোহন",
    "ঘড়ির দিকে তাকিও না; ঘড়ি যা করে তাই করো। এগিয়ে চলো। — স্যাম লেভেনসন",
    "উৎপাদনশীলতা কখনোই দুর্ঘটনা নয়। এটি সর্বদা উৎকর্ষ, পরিকল্পনা এবং মনোযোগী প্রচেষ্টার ফল। — পল জে. মেয়ার",
    "পরিকল্পনা ছাড়া লক্ষ্য শুধু একটি ইচ্ছা। — আন্তোয়ান দ্য সঁ-একজুপেরি"
  ],
  'es': [
    "En verdad, Alá ama a quienes confían en Él. — Corán (3:159)",
    "En verdad, con la dificultad viene la facilidad. — Corán (94:6)",
    "Los mejores entre las personas son los que más beneficio traen a la humanidad. — Profeta Muhammad (la paz sea con él)",
    "El secreto para salir adelante es comenzar. — Mark Twain",
    "El éxito es la suma de pequeños esfuerzos, repetidos día tras día. — Robert Collier",
    "El futuro depende de lo que hagas hoy. — Mahatma Gandhi",
    "La disciplina es el puente entre metas y logros. — Jim Rohn",
    "No mires el reloj; haz lo que él hace. Sigue adelante. — Sam Levenson",
    "La productividad nunca es un accidente. Siempre es el resultado de un compromiso con la excelencia, la planificación y el esfuerzo enfocado. — Paul J. Meyer",
    "Una meta sin un plan es solo un deseo. — Antoine de Saint-Exupéry"
  ],
  'fr': [
    "En vérité, Allah aime ceux qui placent leur confiance en Lui. — Coran (3:159)",
    "En vérité, avec la difficulté vient la facilité. — Coran (94:6)",
    "Les meilleurs parmi les gens sont ceux qui sont les plus utiles à l’humanité. — Prophète Muhammad (paix sur lui)",
    "Le secret pour avancer est de commencer. — Mark Twain",
    "Le succès est la somme de petits efforts, répétés jour après jour. — Robert Collier",
    "L'avenir dépend de ce que tu fais aujourd'hui. — Mahatma Gandhi",
    "La discipline est le pont entre les objectifs et l'accomplissement. — Jim Rohn",
    "Ne regarde pas l'horloge; fais comme elle. Continue d’avancer. — Sam Levenson",
    "La productivité n'est jamais un accident. Elle est toujours le résultat d'un engagement envers l'excellence, la planification et un effort concentré. — Paul J. Meyer",
    "Un objectif sans plan n'est qu’un souhait. — Antoine de Saint-Exupéry"
  ],
  'ar': [
    "إِنَّ اللَّهَ يُحِبُّ الْمُتَوَكِّلِينَ — القرآن (3:159)",
    "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا — القرآن (94:6)",
    "خير الناس أنفعهم للناس. — النبي محمد ﷺ",
    "سر التقدم هو البدء. — مارك توين",
    "النجاح هو مجموع الجهود الصغيرة، المتكررة يوماً بعد يوم. — روبرت كولير",
    "المستقبل يعتمد على ما تفعله اليوم. — مهاتما غاندي",
    "الانضباط هو الجسر بين الأهداف والإنجازات. — جيم رون",
    "لا تراقب الساعة؛ افعل كما تفعل. واصل التقدم. — سام ليفنسون",
    "الإنتاجية ليست صدفة أبداً. إنها دائماً نتيجة الالتزام بالتميز، والتخطيط، والجهد المركز. — بول جي. ماير",
    "الهدف بدون خطة هو مجرد أمنية. — أنطوان دو سانت إكزوبيري"
  ],
  'zh': [
    "的确，真主喜欢信赖他的人。—— 古兰经 (3:159)",
    "的确，艰难之后必有容易。—— 古兰经 (94:6)",
    "最优秀的人是对人类最有益的人。—— 穆罕默德先知（愿主赐他平安）",
    "取得进步的秘诀就是开始。— 马克·吐温",
    "成功是小努力日积月累的结果。— 罗伯特·科利尔",
    "未来取决于你今天所做的事。— 圣雄甘地",
    "自律是目标与成就之间的桥梁。— 吉姆·罗恩",
    "不要看钟表；要像它一样继续前进。— 山姆·莱文森",
    "生产力从来不是偶然的。它总是卓越、计划和专注努力的结果。— 保罗·J·迈耶",
    "没有计划的目标只是一个愿望。— 圣埃克苏佩里"
  ],
};
String tr(String key, Locale? locale) {
  final lang = (locale?.languageCode ?? 'en');
  return localizedStrings[key]?[lang] ?? localizedStrings[key]?['en'] ?? key;
}

List<String> getQuotesForLocale(Locale? locale) {
  final lang = (locale?.languageCode ?? 'en');
  return localizedQuotes[lang] ?? localizedQuotes['en']!;
}

class Task {
  String name;
  String description;
  DateTime dueDate;
  DateTime addedTime;
  Color priorityColor;
  List<String> attachmentPaths;
  DateTime? reminderTime;

  Task({
    required this.name,
    required this.description,
    required this.dueDate,
    required this.addedTime,
    required this.priorityColor,
    required this.attachmentPaths,
    this.reminderTime,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'addedTime': addedTime.toIso8601String(),
        'priorityColor': priorityColor.value,
        'attachmentPaths': attachmentPaths,
        'reminderTime': reminderTime?.toIso8601String(),
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
        name: json['name'],
        description: json['description'],
        dueDate: DateTime.parse(json['dueDate']),
        addedTime: DateTime.parse(json['addedTime']),
        priorityColor: Color(json['priorityColor']),
        attachmentPaths: json['attachmentPaths'] != null
            ? List<String>.from(json['attachmentPaths'])
            : [],
        reminderTime: json['reminderTime'] != null
            ? DateTime.tryParse(json['reminderTime'])
            : null,
      );
}

class TasksScreen extends StatefulWidget {
  final ThemeMode? themeMode;
  final void Function(ThemeMode)? onThemeModeChanged;
  final MaterialColor? primarySwatch;
  final void Function(MaterialColor)? onSwatchChanged;
  final Locale? locale;
  final void Function(Locale)? onLocaleChanged;

  const TasksScreen({
    Key? key,
    this.themeMode,
    this.onThemeModeChanged,
    this.primarySwatch,
    this.onSwatchChanged,
    this.locale,
    this.onLocaleChanged,
  }) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  List<bool> completed = [];
  late List<String> quotes;
  int _currentQuoteIndex = 0;
  Timer? _quoteTimer;

  final List<Color> colorOptions = [Color(0xFFC6426E), Color(0xFF17EAD9), kAccentYellow, kAccentBlue];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ----- TEXT TO SPEECH -----
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initNotifications();
    _initTTS();
    loadTasks();
    _initQuotes();
    _startQuoteRotation();
  }

  Future<void> _initTTS() async {
    await flutterTts.setLanguage(widget.locale?.languageCode ?? 'en');
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  void _speak(String text) async {
    await flutterTts.stop();
    await flutterTts.speak(text);
  }

  void _speakTask(Task task, int index) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final due = dateFormat.format(task.dueDate);
    final desc = task.description.isNotEmpty ? task.description : '';
    final reminder = task.reminderTime != null
        ? " ${tr('reminder', widget.locale)}: ${DateFormat('yyyy-MM-dd HH:mm').format(task.reminderTime!)}."
        : "";
    final attachments = task.attachmentPaths.isNotEmpty
        ? " ${task.attachmentPaths.length} ${tr('file', widget.locale)} attached."
        : "";
    final text =
        "${tr('task_name', widget.locale)}: ${task.name}. ${tr('description', widget.locale)}: $desc. ${tr('due_date', widget.locale)}: $due.$reminder$attachments";
    _speak(text);
  }

  void _speakQuote() {
    _speak(quotes[_currentQuoteIndex]);
  }

  void _initQuotes() {
    quotes = getQuotesForLocale(widget.locale);
  }

  @override
  void didUpdateWidget(covariant TasksScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.locale?.languageCode != oldWidget.locale?.languageCode) {
      setState(() {
        quotes = getQuotesForLocale(widget.locale);
        _currentQuoteIndex = 0;
      });
      _initTTS();
    }
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const DarwinInitializationSettings initializationSettingsMacOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        if (Platform.isAndroid || Platform.isIOS) {
          if (await Vibrate.canVibrate) {
            Vibrate.vibrate();
          }
        }
      },
    );
    if (Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  void _startQuoteRotation() {
    _quoteTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {
        _currentQuoteIndex = (_currentQuoteIndex + 1) % quotes.length;
      });
    });
  }

  @override
  void dispose() {
    _quoteTimer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
    await prefs.setStringList('completed', completed.map((e) => e ? '1' : '0').toList());
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? tasksJson = prefs.getStringList('tasks');
    final List<String>? completedJson = prefs.getStringList('completed');
    if (tasksJson != null) {
      setState(() {
        tasks = tasksJson.map((jsonStr) => Task.fromJson(jsonDecode(jsonStr))).toList();
        if (completedJson != null && completedJson.length == tasks.length) {
          completed = completedJson.map((e) => e == '1').toList();
        } else {
          completed = List<bool>.filled(tasks.length, false);
        }
      });
    }
  }

  Future<void> _zonedScheduleReminder(Task task, int id) async {
    if (task.reminderTime == null) return;
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "Task Reminder",
      task.name,
      tz.TZDateTime.from(task.reminderTime!, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'task_channel', 'Task Channel',
            importance: Importance.max, priority: Priority.high, enableVibration: true),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: task.description,
      matchDateTimeComponents: null,
    );
  }

    void _showTaskDialog({Task? task, int? editIndex}) async {
    final nameController = TextEditingController(text: task?.name ?? "");
    final descriptionController = TextEditingController(text: task?.description ?? "");
    DateTime? selectedDate = task?.dueDate;
    Color selectedColor = task?.priorityColor ?? colorOptions[0];
    List<String> attachments = List<String>.from(task?.attachmentPaths ?? []);
    DateTime? reminderTime = task?.reminderTime;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> pickFiles() async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowMultiple: true,
                allowedExtensions: [
                  'jpg', 'jpeg', 'png', 'gif',
                  'txt', 'pdf', 'doc', 'docx', 'xls', 'xlsx',
                  'mp4', 'mov', 'avi', 'wmv', 'webm'
                ],
              );
              if (result != null) {
                setStateDialog(() {
                  attachments.addAll(result.paths.whereType<String>());
                });
              }
            }
            Future<void> pickReminderDateTime() async {
              final now = DateTime.now();
              final date = await showDatePicker(
                context: context,
                initialDate: reminderTime ?? now,
                firstDate: now,
                lastDate: now.add(const Duration(days: 365 * 5)),
              );
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: reminderTime != null
                      ? TimeOfDay.fromDateTime(reminderTime!)
                      : TimeOfDay.now(),
                );
                if (time != null) {
                  setStateDialog(() {
                    reminderTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                  });
                }
              }
            }
            Widget attachmentPreview() {
              if (attachments.isEmpty) return Container();
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: attachments.map((path) {
                  final ext = path.split('.').last.toLowerCase();
                  Widget icon;
                  if (['jpg', 'jpeg', 'png', 'gif'].contains(ext)) {
                    icon = GestureDetector(
                      onTap: () => _openAttachment(context, path),
                      child: Image.file(
                        File(path),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 48),
                      ),
                    );
                  } else if (['mp4', 'mov', 'avi', 'wmv', 'webm'].contains(ext)) {
                    icon = GestureDetector(
                      onTap: () => _openAttachment(context, path),
                      child: Container(
                        width: 48,
                        height: 48,
                        color: kAccentBlue.withOpacity(0.15),
                        child: const Icon(Icons.videocam, size: 32, color: Colors.deepOrange),
                      ),
                    );
                  } else {
                    icon = GestureDetector(
                      onTap: () => _openAttachment(context, path),
                      child: const Icon(Icons.description, size: 48, color: kAccentBlue),
                    );
                  }
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      icon,
                      Positioned(
                        right: -8,
                        top: -8,
                        child: GestureDetector(
                          onTap: () {
                            setStateDialog(() {
                              attachments.remove(path);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kGradientStart.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          ),
                        ),
                      )
                    ],
                  );
                }).toList(),
              );
            }

            return AlertDialog(
              backgroundColor: kGradientStart.withOpacity(0.92),
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: kTextWhite, fontSize: 20
              ),
              contentTextStyle: const TextStyle(
                color: kTextWhite
              ),
              title: Text(editIndex == null
                  ? tr('add_task', widget.locale)
                  : tr('edit_task', widget.locale)
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: kAccentCyan),
                      decoration: InputDecoration(
                        labelText: tr('task_name', widget.locale),
                        labelStyle: const TextStyle(color: kAccentCyan),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kAccentCyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kAccentYellow),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      style: const TextStyle(color: kTextWhite),
                      decoration: InputDecoration(
                        labelText: tr('description', widget.locale),
                        labelStyle: const TextStyle(color: kTextWhite),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kAccentBlue),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kAccentYellow),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(tr('due_date', widget.locale) + ':', style: const TextStyle(color: kAccentYellow)),
                        const SizedBox(width: 8),
                        Text(
                          selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : tr('not_selected', widget.locale),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: kTextWhite),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.calendar_today, color: kAccentYellow),
                          onPressed: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? now,
                              firstDate: now.subtract(const Duration(days: 365)),
                              lastDate: now.add(const Duration(days: 365 * 5)),
                            );
                            if (picked != null) {
                              setStateDialog(() {
                                selectedDate = picked;
                              });
                            }
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text("${tr('priority', widget.locale)}: ", style: const TextStyle(color: kAccentYellow)),
                        ...colorOptions.map((color) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: GestureDetector(
                                onTap: () => setStateDialog(() => selectedColor = color),
                                child: CircleAvatar(
                                  backgroundColor: color,
                                  radius: 13,
                                  child: selectedColor == color
                                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                                      : null,
                                ),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.attach_file),
                          label: Text(tr('add_attachment', widget.locale)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentCyan,
                            foregroundColor: Colors.black87,
                          ),
                          onPressed: pickFiles,
                        ),
                        const SizedBox(width: 10),
                        if (attachments.isNotEmpty)
                          Text("${attachments.length} ${tr('file', widget.locale)}", style: const TextStyle(fontSize: 13, color: kAccentCyan)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    attachmentPreview(),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.alarm),
                          label: Text(tr('set_reminder', widget.locale)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentYellow,
                            foregroundColor: Colors.black87,
                          ),
                          onPressed: pickReminderDateTime,
                        ),
                        const SizedBox(width: 10),
                        if (reminderTime != null)
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(reminderTime!),
                            style: const TextStyle(fontSize: 13, color: kAccentYellow),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(tr('cancel', widget.locale), style: const TextStyle(color: kAccentYellow)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty || selectedDate == null) return;
                    setState(() {
                      if (editIndex == null) {
                        tasks.add(Task(
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          dueDate: selectedDate!,
                          addedTime: DateTime.now(),
                          priorityColor: selectedColor,
                          attachmentPaths: attachments,
                          reminderTime: reminderTime,
                        ));
                        completed.add(false);
                      } else {
                        tasks[editIndex] = Task(
                          name: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                          dueDate: selectedDate!,
                          addedTime: tasks[editIndex].addedTime,
                          priorityColor: selectedColor,
                          attachmentPaths: attachments,
                          reminderTime: reminderTime,
                        );
                      }
                      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
                    });
                    await saveTasks();
                    if (reminderTime != null) {
                      final taskId = editIndex ?? tasks.length - 1;
                      await _zonedScheduleReminder(tasks[taskId], taskId);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(editIndex == null ? tr('add', widget.locale) : tr('save', widget.locale)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      if (index < completed.length) completed.removeAt(index);
    });
    saveTasks();
  }

  void _toggleComplete(int index) {
    setState(() {
      if (completed.length <= index) {
        completed.add(false);
      }
      completed[index] = !completed[index];
    });
    saveTasks();
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _openAttachment(BuildContext context, String path) {
    final ext = path.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif'].contains(ext)) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ImagePreviewScreen(imagePath: path),
      ));
    } else if (['mp4', 'mov', 'avi', 'wmv', 'webm'].contains(ext)) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => VideoPreviewScreen(videoPath: path),
      ));
    } else {
      OpenFile.open(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');
    final loc = widget.locale;

    final int total = tasks.length;
    final int done = completed.where((e) => e).length;
    final double progress = total == 0 ? 0 : done / total;

    return Container(
      decoration: const BoxDecoration(
        gradient: kBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _speakQuote,
                    child: Text(
                      quotes[_currentQuoteIndex],
                      key: ValueKey(_currentQuoteIndex),
                      style: const TextStyle(fontSize: 16, color: kAccentCyan),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, color: kAccentYellow),
                  onPressed: _speakQuote,
                  tooltip: "Read aloud quote",
                ),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language, color: kAccentYellow),
              tooltip: "Change Language",
              onSelected: (locale) => widget.onLocaleChanged?.call(locale),
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
            // --- Attractive Add Task Button ---
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  backgroundColor: kAccentYellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  shadowColor: kAccentYellow.withOpacity(0.4),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 24, color: kAccentBlue),
                label: Text(tr('add_task', widget.locale)),
                onPressed: () => _showTaskDialog(),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(gradient: kBackgroundGradient),
                child: Text(tr('menu', loc), style: const TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.task, color: kAccentBlue),
                title: Text(tr('tasks', loc), style: const TextStyle(color: kTextWhite)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.school, color: kAccentYellow),
                title: Text(tr('learning', loc), style: const TextStyle(color: kTextWhite)),
                onTap: () {
                  _navigateTo(context, const LearningScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.self_improvement, color: kAccentCyan),
                title: Text(tr('wellbeing', loc), style: const TextStyle(color: kTextWhite)),
                onTap: () {
                  _navigateTo(context, const WellbeingScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_emotions, color: kAccentYellow),
                title: Text(tr('jokes', loc), style: const TextStyle(color: kTextWhite)),
                onTap: () {
                  _navigateTo(context, const JokeScreen());
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            if (tasks.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: kAccentCyan.withOpacity(0.25),
                      valueColor: AlwaysStoppedAnimation<Color>(kAccentYellow),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}% completed ($done/$total)",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: kAccentYellow),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: tasks.isEmpty
                  ? Center(child: Text(tr('no_tasks', loc), style: const TextStyle(color: kTextWhite)))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        final isComplete = completed.length > index ? completed[index] : false;
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          color: kGradientStart.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 6,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12.0),
                            leading: GestureDetector(
                              onTap: () => _toggleComplete(index),
                              child: CircleAvatar(
                                backgroundColor: task.priorityColor,
                                radius: 18,
                                child: isComplete
                                    ? const Icon(Icons.check, color: Colors.white)
                                    : null,
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _speakTask(task, index),
                                    child: Text(
                                      task.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: isComplete
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: isComplete ? Colors.grey : kTextWhite,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.volume_up, color: kAccentCyan),
                                  onPressed: () => _speakTask(task, index),
                                  tooltip: "Read aloud task",
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      timeFormat.format(task.addedTime),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: kTextFaint,
                                      ),
                                    ),
                                    Text(
                                      dateFormat.format(task.addedTime),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: kTextFaint,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (task.description.isNotEmpty) ...[
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                      decoration: isComplete
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      color: isComplete ? Colors.grey : kTextWhite,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                Text(
                                  "${tr('due_date', loc)}: ${dateFormat.format(task.dueDate)}",
                                  style: const TextStyle(fontSize: 13, color: kAccentYellow),
                                ),
                                if (task.reminderTime != null)
                                  Text(
                                    "${tr('reminder', loc)}: ${DateFormat('yyyy-MM-dd HH:mm').format(task.reminderTime!)}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: kAccentCyan,
                                    ),
                                  ),
                                if (task.attachmentPaths.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: task.attachmentPaths.map((path) {
                                        final ext = path.split('.').last.toLowerCase();
                                        Widget icon;
                                        if (['jpg', 'jpeg', 'png', 'gif'].contains(ext)) {
                                          icon = GestureDetector(
                                            onTap: () => _openAttachment(context, path),
                                            child: Image.file(
                                              File(path),
                                              width: 32,
                                              height: 32,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.broken_image, size: 32),
                                            ),
                                          );
                                        } else if (['mp4', 'mov', 'avi', 'wmv', 'webm'].contains(ext)) {
                                          icon = GestureDetector(
                                            onTap: () => _openAttachment(context, path),
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              color: kAccentBlue.withOpacity(0.15),
                                              child: const Icon(Icons.videocam, size: 24, color: Colors.deepOrange),
                                            ),
                                          );
                                        } else {
                                          icon = GestureDetector(
                                            onTap: () => _openAttachment(context, path),
                                            child: const Icon(Icons.description, size: 32, color: kAccentBlue),
                                          );
                                        }
                                        return icon;
                                      }).toList(),
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isComplete ? Icons.check_box : Icons.check_box_outline_blank,
                                    color: isComplete ? kAccentCyan : kAccentYellow,
                                  ),
                                  tooltip: isComplete ? "Mark as incomplete" : "Mark as complete",
                                  onPressed: () => _toggleComplete(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: kAccentYellow),
                                  tooltip: tr('edit_task', loc),
                                  onPressed: () => _showTaskDialog(task: task, editIndex: index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  tooltip: 'Delete',
                                  onPressed: () => _deleteTask(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Image preview screen
class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;
  const ImagePreviewScreen({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGradientStart,
      appBar: AppBar(backgroundColor: kGradientMiddle),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}

// Video preview screen
class VideoPreviewScreen extends StatefulWidget {
  final String videoPath;
  const VideoPreviewScreen({super.key, required this.videoPath});
  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) => setState(() {}));
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGradientStart,
      appBar: AppBar(backgroundColor: kGradientMiddle),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccentYellow,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black),
      ),
    );
  }
}
