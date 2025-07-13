import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/user_progress.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({Key? key}) : super(key: key);

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  final TextEditingController _referralController = TextEditingController();

  Future<void> _launchUri(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  void _simulateFriendAccepted() {
    setState(() {
      UserProgress.totalPoints += 5;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend joined! You earned 5 points!')),
    );
  }

  @override
  void dispose() {
    _referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invite Friends')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.email),
              label: const Text('Invite via Email'),
              onPressed: () {
                final subject = Uri.encodeComponent('Join me on Gym Progress Tracker');
                final body = Uri.encodeComponent(
                    'Hey! I\'ve been using this app to track my workouts. Join me with referral code: \\${_referralController.text}');
                final emailUri = Uri.parse('mailto:?subject=$subject&body=$body');
                _launchUri(emailUri);
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.facebook),
              label: const Text('Invite via Facebook'),
              onPressed: () {
                _launchUri(Uri.parse('https://facebook.com'));
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _referralController,
              decoration: const InputDecoration(
                labelText: 'Referral Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _simulateFriendAccepted,
              child: const Text('Simulate Friend Accepted'),
            ),
          ],
        ),
      ),
    );
  }
} 