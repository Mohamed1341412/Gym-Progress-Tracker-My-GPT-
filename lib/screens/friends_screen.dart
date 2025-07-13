import 'package:flutter/material.dart';
import '../services/mock_database.dart';
import '../screens/chat_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  void _openChat(String name) {
    Navigator.pushNamed(context, '/chat', arguments: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friends'),
        actions:[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: (){
              Navigator.pushNamed(context, '/friendRequests');
            },
          )],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Friends', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Expanded(
              child: MockDatabase.friends.isEmpty
                  ? const Center(child: Text('No friends yet.'))
                  : ListView.builder(
                      itemCount: MockDatabase.friends.length,
                      itemBuilder: (context, index) {
                        final name = MockDatabase.friends[index];
                        return ListTile(
                          leading: _avatarForName(name),
                          title: Text(name),
                          trailing: ElevatedButton(
                            onPressed: () => _openChat(name),
                            child: const Text('Message'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarForName(String name) {
    return CircleAvatar(
      child: Text(name.substring(0, 1)),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
} 