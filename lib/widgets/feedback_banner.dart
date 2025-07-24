import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/user_progress.dart';

class FeedbackBanner extends StatefulWidget {
  const FeedbackBanner({Key? key}) : super(key: key);

  @override
  State<FeedbackBanner> createState() => _FeedbackBannerState();
}

class _FeedbackBannerState extends State<FeedbackBanner> {
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    UserProgress.latestFeedback.addListener(_resetTimer);
  }

  void _resetTimer() {
    _hideTimer?.cancel();
    if (UserProgress.latestFeedback.value != null) {
      _hideTimer = Timer(const Duration(seconds: 5), () {
        UserProgress.latestFeedback.value = null;
      });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    UserProgress.latestFeedback.removeListener(_resetTimer);
    super.dispose();
  }

  Color _bg(String msg) {
    final lower = msg.toLowerCase();
    if (lower.contains('up') || lower.contains('great') || lower.contains('nice')) {
      return Colors.green.withOpacity(0.7);
    } else if (lower.contains('push') || lower.contains('harder')) {
      return Colors.orange.withOpacity(0.7);
    } else if (lower.contains('dropped') || lower.contains('decline')) {
      return Colors.red.withOpacity(0.7);
    }
    return Colors.blue.withOpacity(0.6);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: UserProgress.latestFeedback,
      builder: (context, value, _) {
        if (value == null) return const SizedBox.shrink();
        return AnimatedOpacity(
          opacity: value.isNotEmpty ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: Material(
            color: _bg(value),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(value,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => UserProgress.latestFeedback.value = null,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 