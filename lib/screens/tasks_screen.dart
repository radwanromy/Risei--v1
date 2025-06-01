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
import 'learning_screen.dart';
import 'wellbeing_screen.dart';
import 'joke_screen.dart';

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
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  final List<Color> colorOptions = [Colors.red, Colors.orange, Colors.green, Colors.blue];

  final List<String> quotes = [
    "The secret of getting ahead is getting started. — Mark Twain",
    "Success is the sum of small efforts, repeated day in and day out. — Robert Collier",
    "The future depends on what you do today. — Mahatma Gandhi",
    "Discipline is the bridge between goals and accomplishment. — Jim Rohn",
    "Don’t watch the clock; do what it does. Keep going. — Sam Levenson",
    "Productivity is never an accident. It is always the result of a commitment to excellence, planning, and focused effort. — Paul J. Meyer",
    "A goal without a plan is just a wish. — Antoine de Saint-Exupéry"
  ];
  int _currentQuoteIndex = 0;
  Timer? _quoteTimer;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initNotifications();
    loadTasks();
    _startQuoteRotation();
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
        // Vibrate on notification tap (not available on macOS)
        if (Platform.isAndroid || Platform.isIOS) {
          if (await Vibrate.canVibrate) {
            Vibrate.vibrate();
          }
        }
      },
    );

    // Request permissions for macOS
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
    super.dispose();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? tasksJson = prefs.getStringList('tasks');
    if (tasksJson != null) {
      setState(() {
        tasks = tasksJson.map((jsonStr) => Task.fromJson(jsonDecode(jsonStr))).toList();
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
                  'jpg', 'jpeg', 'png', 'gif',         // images
                  'txt', 'pdf', 'doc', 'docx', 'xls', 'xlsx', // docs
                  'mp4', 'mov', 'avi', 'wmv', 'webm'   // videos
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
              title: Text(editIndex == null ? 'Add Task' : 'Edit Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Task Name'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Due Date:'),
                        const SizedBox(width: 8),
                        Text(
                          selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : "Not selected",
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
                        const Text("Priority: "),
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
                          label: const Text("Add Attachment"),
                          onPressed: pickFiles,
                        ),
                        const SizedBox(width: 10),
                        if (attachments.isNotEmpty)
                          Text("${attachments.length} file(s)", style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    attachmentPreview(),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.alarm),
                          label: const Text("Set Reminder"),
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
                  child: const Text('Cancel'),
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
                  child: Text(editIndex == null ? 'Add' : 'Save'),
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

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFb2fefa), Color(0xFF0ed2f7), Color(0xFF1fa2ff)],
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
            child: Text(
              quotes[_currentQuoteIndex],
              key: ValueKey(_currentQuoteIndex),
              style: const TextStyle(fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black87,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: "Add Task",
              onPressed: () => _showTaskDialog(),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.black87),
                child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ListTile(
                leading: const Icon(Icons.task),
                title: const Text('Tasks'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Learning'),
                onTap: () {
                  _navigateTo(context, const LearningScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.self_improvement),
                title: const Text('Well-being'),
                onTap: () {
                  _navigateTo(context, const WellbeingScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_emotions),
                title: const Text('Jokes'),
                onTap: () {
                  _navigateTo(context, const JokeScreen());
                },
              ),
            ],
          ),
        ),
        body: tasks.isEmpty
            ? const Center(child: Text("No tasks yet."))
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12.0),
                      leading: CircleAvatar(
                        backgroundColor: task.priorityColor,
                        radius: 18,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                            Text(task.description),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            "Due: ${dateFormat.format(task.dueDate)}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          if (task.reminderTime != null)
                            Text(
                              "Reminder: ${DateFormat('yyyy-MM-dd HH:mm').format(task.reminderTime!)}",
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
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit',
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
