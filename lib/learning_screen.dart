import 'package:flutter/material.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with actual quote retrieval logic (e.g., from a local list or API)
    const String quote = "The only way to do great work is to love what you do. - Steve Jobs";
    const String learningResources = "https://www.khanacademy.org/"; // Example resource

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quote of the Day',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              quote,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            const Text(
              'Learning Resources',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              child: const Text(
                'Khan Academy',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              onTap: () {
                // Implement URL launching here (requires the url_launcher package)
                // launch(learningResources); // Example: launch(Uri.parse(learningResources));
              },
            ),
          ],
        ),
      ),
    );
  }
}
