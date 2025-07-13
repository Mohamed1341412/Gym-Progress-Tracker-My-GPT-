import 'package:flutter/material.dart';
import '../utils/user_progress.dart';
import '../models/workout_model.dart';

class AiAssistantChatScreen extends StatefulWidget {
  const AiAssistantChatScreen({Key? key}) : super(key: key);

  @override
  State<AiAssistantChatScreen> createState() => _AiAssistantChatScreenState();
}

class _AiAssistantChatScreenState extends State<AiAssistantChatScreen> {
  final List<Map<String, String>> _messages = [
    {'sender': 'ai', 'text': "Hi, I'm GPT! Ask me anything about your training, progress, or what you should work on today 💪"},
  ];
  final TextEditingController _controller = TextEditingController();

  String _mockAiResponse(String prompt) {
    final lower = prompt.toLowerCase();

    // 1. Suggest muscle group to train
    if (lower.contains('what should i train')) {
      if (UserProgress.workoutHistory.isEmpty) {
        return 'You have no logged workouts yet. How about starting with a full-body routine?';
      }
      // Determine the category not trained for the longest time
      final Map<String, DateTime> lastTrained = {};
      for (final w in UserProgress.workoutHistory) {
        lastTrained[w.category] = lastTrained.containsKey(w.category)
            ? (w.date.isAfter(lastTrained[w.category]!) ? w.date : lastTrained[w.category]!)
            : w.date;
      }
      // Find oldest date
      String? targetCat;
      int maxDays = -1;
      final now = DateTime.now();
      lastTrained.forEach((cat, date) {
        final days = now.difference(date).inDays;
        if (days > maxDays) {
          maxDays = days;
          targetCat = cat;
        }
      });
      if (targetCat != null) {
        if (maxDays >= 7) {
          return "It's been $maxDays days since your last $targetCat workout. Let's hit $targetCat today!";
        }
        return 'Your most balanced option today would be $targetCat.';
      }
    }

    // 2. Volume dropping question
    if (lower.contains('why is my volume dropping')) {
      return 'You may be overtraining or not recovering enough. Try reducing sets slightly or adding rest.';
    }

    // 3. Workout plan request
    if (lower.contains('make me a workout plan')) {
      return 'Here's a simple 3-day split:\n• Day 1: Push (Chest, Shoulders, Triceps)\n• Day 2: Pull (Back, Biceps)\n• Day 3: Legs';
    }

    // Default fallback
    return "I'm still learning. Try asking about your progress, recovery, or training schedule.";
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _controller.clear();
    });
    // Simulate AI response after short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _messages.add({'sender': 'ai', 'text': _mockAiResponse(text)});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPT – Your AI Gym Coach')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.grey[300] : Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask me anything...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 