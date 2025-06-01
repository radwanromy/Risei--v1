import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JokeScreen extends StatefulWidget {
  const JokeScreen({Key? key}) : super(key: key);

  @override
  State<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  String _joke = "Press the button to get a random joke!";

  Future<void> fetchJoke() async {
    setState(() {
      _joke = "Loading...";
    });
    final response = await http.get(Uri.parse('https://v2.jokeapi.dev/joke/Any'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        if (data['type'] == 'single') {
          _joke = data['joke'];
        } else if (data['type'] == 'twopart') {
          _joke = "${data['setup']}\n\n${data['delivery']}";
        } else {
          _joke = "Couldn't parse the joke!";
        }
      });
    } else {
      setState(() {
        _joke = "Failed to fetch joke. Try again!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_joke, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.emoji_emotions),
              label: const Text("Get Random Joke"),
              onPressed: fetchJoke,
            ),
          ],
        ),
      ),
    );
  }
}
