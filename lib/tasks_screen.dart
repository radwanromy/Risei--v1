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

// ... [localizedStrings, localizedQuotes, tr, getQuotesForLocale, Task class, etc. remain unchanged] ...

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

  final List<Color> colorOptions = [Colors.red, Colors.orange, Colors.green, Colors.blue];

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
    // ... [unchanged, as before] ...
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
                        color: Colors.black12,
                        child: const Icon(Icons.videocam, size: 32, color: Colors.deepOrange),
                      ),
                    );
                  } else {
                    icon = GestureDetector(
                      onTap: () => _openAttachment(context, path),
                      child: const Icon(Icons.description, size: 48, color: Colors.blueGrey),
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
                            decoration: const BoxDecoration(
                              color: Colors.black54,
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
                      decoration: InputDecoration(labelText: tr('task_name', widget.locale)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(labelText: tr('description', widget.locale)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(tr('due_date', widget.locale) + ':'),
                        const SizedBox(width: 8),
                        Text(
                          selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : tr('not_selected', widget.locale),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
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
                        Text("${tr('priority', widget.locale)}: "),
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
                          onPressed: pickFiles,
                        ),
                        const SizedBox(width: 10),
                        if (attachments.isNotEmpty)
                          Text("${attachments.length} ${tr('file', widget.locale)}", style: const TextStyle(fontSize: 13)),
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
                          onPressed: pickReminderDateTime,
                        ),
                        const SizedBox(width: 10),
                        if (reminderTime != null)
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(reminderTime!),
                            style: const TextStyle(fontSize: 13, color: Colors.indigo),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(tr('cancel', widget.locale)),
                ),
                ElevatedButton(
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
        gradient: LinearGradient(
          colors: [Color(0xFF341f97), Color(0xFF0ed2f7), Color(0xFF1fa2ff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
                      style: const TextStyle(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: _speakQuote,
                  tooltip: "Read aloud quote",
                ),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black87,
          actions: [
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language),
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
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: tr('add_task', widget.locale),
              onPressed: () => _showTaskDialog(),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.black87),
                child: Text(tr('menu', loc), style: const TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.task),
                title: Text(tr('tasks', loc)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: Text(tr('learning', loc)),
                onTap: () {
                  _navigateTo(context, const LearningScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.self_improvement),
                title: Text(tr('wellbeing', loc)),
                onTap: () {
                  _navigateTo(context, const WellbeingScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_emotions),
                title: Text(tr('jokes', loc)),
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
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${(progress * 100).toStringAsFixed(0)}% completed ($done/$total)",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: tasks.isEmpty
                  ? Center(child: Text(tr('no_tasks', loc)))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        final isComplete = completed.length > index ? completed[index] : false;
                        return Card(
                          margin: const EdgeInsets.all(8.0),
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
                                        color: isComplete ? Colors.grey : null,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.volume_up),
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
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      dateFormat.format(task.addedTime),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
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
                                      color: isComplete ? Colors.grey : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                Text(
                                  "${tr('due_date', loc)}: ${dateFormat.format(task.dueDate)}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                if (task.reminderTime != null)
                                  Text(
                                    "${tr('reminder', loc)}: ${DateFormat('yyyy-MM-dd HH:mm').format(task.reminderTime!)}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.deepOrange,
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
                                              color: Colors.black12,
                                              child: const Icon(Icons.videocam, size: 24, color: Colors.deepOrange),
                                            ),
                                          );
                                        } else {
                                          icon = GestureDetector(
                                            onTap: () => _openAttachment(context, path),
                                            child: const Icon(Icons.description, size: 32, color: Colors.blueGrey),
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
                                    color: isComplete ? Colors.green : null,
                                  ),
                                  tooltip: isComplete ? "Mark as incomplete" : "Mark as complete",
                                  onPressed: () => _toggleComplete(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: tr('edit_task', loc),
                                  onPressed: () => _showTaskDialog(task: task, editIndex: index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
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
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
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
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
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
