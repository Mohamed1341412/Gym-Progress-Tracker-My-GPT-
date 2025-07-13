import 'package:flutter/material.dart';
import '../utils/user_progress.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const mockName = 'John Doe';
    const mockAge = 28;
    const mockHeight = 180; // cm
    const mockWeight = 80; // kg
    const mockBloodType = 'O+';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                child: Text(
                  mockName.split(' ').map((e) => e[0]).take(2).join(),
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                mockName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoRow(label: 'Age', value: '$mockAge'),
                    _InfoRow(label: 'Height', value: '$mockHeight cm'),
                    _InfoRow(label: 'Weight', value: '$mockWeight kg'),
                    _InfoRow(label: 'Blood Type', value: mockBloodType),
                    _InfoRow(label: 'Total Points', value: '${UserProgress.totalPoints}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Security Settings'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/inviteFriends');
              },
              child: const Text('Invite Friends'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/leaderboard');
              },
              child: const Text('View Leaderboard'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
} 