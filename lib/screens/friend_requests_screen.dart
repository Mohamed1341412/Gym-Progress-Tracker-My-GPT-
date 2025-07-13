import 'package:flutter/material.dart';
import '../services/mock_database.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({Key? key}) : super(key: key);

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  void _accept(String name) {
    setState(() {
      MockDatabase.pendingRequests.remove(name);
      if (!MockDatabase.friends.contains(name)) {
        MockDatabase.friends.add(name);
      }
    });
  }

  void _decline(String name) {
    setState(() {
      MockDatabase.pendingRequests.remove(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friend Requests')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: MockDatabase.pendingRequests.length,
        itemBuilder: (context, index) {
          final name = MockDatabase.pendingRequests[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(name.substring(0, 1))),
              title: Text(name),
              subtitle: const Text('wants to be your friend'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _accept(name),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _decline(name),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 