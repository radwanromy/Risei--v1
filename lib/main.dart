import 'package:flutter/material.dart';
import 'screens/tasks_screen.dart';
import 'screens/learning_screen.dart';
import 'screens/wellbeing_screen.dart';
import 'screens/joke_screen.dart';

void main() => runApp(const RiseiApp());

class RiseiApp extends StatelessWidget {
  const RiseiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Risei',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.indigo,
        fontFamily: 'Nunito',
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TasksScreen(),
    LearningScreen(),
    WellbeingScreen(),
    JokeScreen(),
  ];

  final List<String> _titles = [
    'Tasks',
    'Learning',
    'Well-being',
    'Jokes',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.black87,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.white70,
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
        ],
      ),
    );
  }
}
