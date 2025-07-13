import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data
    final worldUsers = [
      _UserScore('Alice', 150, 'USA'),
      _UserScore('Bob', 140, 'Canada'),
      _UserScore('Charlie', 135, 'UK'),
      _UserScore('Dave', 130, 'Germany'),
      _UserScore('Eve', 125, 'France'),
      _UserScore('Frank', 120, 'Japan'),
      _UserScore('Grace', 118, 'Italy'),
      _UserScore('Heidi', 115, 'Spain'),
      _UserScore('Ivan', 110, 'Russia'),
      _UserScore('Judy', 105, 'Brazil'),
    ];

    final countryUsers = [
      _UserScore('Alice', 150, 'USA'),
      _UserScore('Mallory', 132, 'USA'),
      _UserScore('Oscar', 117, 'USA'),
      _UserScore('Peggy', 99, 'USA'),
      _UserScore('Sybil', 88, 'USA'),
    ];

    final friendNames = ['Alice', 'Bob']; // Should match mock friends list
    final friendUsers = [
      _UserScore('Alice', 150, 'USA'),
      _UserScore('Bob', 140, 'Canada'),
    ];

    // Sort lists by points descending (already but ensure)
    worldUsers.sort((a, b) => b.points.compareTo(a.points));
    countryUsers.sort((a, b) => b.points.compareTo(a.points));
    friendUsers.sort((a, b) => b.points.compareTo(a.points));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Leaderboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'World'),
              Tab(text: 'Country'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _LeaderboardList(users: worldUsers),
            _LeaderboardList(users: countryUsers),
            _LeaderboardList(users: friendUsers),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  final List<_UserScore> users;
  const _LeaderboardList({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(user.name.substring(0, 1)),
          ),
          title: Text(user.name),
          subtitle: user.country != null ? Text(user.country!) : null,
          trailing: Text('${user.points} pts'),
        );
      },
    );
  }
}

class _UserScore {
  final String name;
  final int points;
  final String? country;
  _UserScore(this.name, this.points, [this.country]);
} 