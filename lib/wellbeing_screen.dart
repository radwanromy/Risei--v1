import 'package:flutter/material.dart';

class WellbeingScreen extends StatelessWidget {
  const WellbeingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mindfulness Exercise',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Take a deep breath and focus on your surroundings. Notice five things you can see, four things you can touch, three things you can hear, two things you can smell, and one thing you can taste.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sleep Sounds',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Add a list of sleep sounds (e.g., nature sounds, white noise)
            // Implement audio playback using a package like audioplayers
            const Text('Coming Soon...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
