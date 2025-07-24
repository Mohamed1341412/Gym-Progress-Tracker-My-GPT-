import 'package:flutter/material.dart';
import '../services/friend_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/friend_model.dart';
import 'package:badges/badges.dart' as badges;

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  void _openChat(String name) {
    Navigator.pushNamed(context, '/chat', arguments: name);
  }

  final service = FriendService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friends'),
        actions:[
          StreamBuilder<List<Friend>>(stream: service.requestsStream(), builder: (c,s){
            final count = s.data?.length ?? 0;
            return badges.Badge(
              showBadge: count>0,
              badgeContent: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10)),
              child: IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => Navigator.pushNamed(context, '/friendRequests'),
              ),
            );
          })],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Friends', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<Friend>>(
                stream: service.friendsStream(),
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data ?? [];
                  if(data.isEmpty){
                    return const Center(child: Text('No friends yet.'));
                  }
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index){
                      final friend = data[index];
                      return ListTile(
                        leading: Text(friend.flagEmoji, style: const TextStyle(fontSize: 24)),
                        title: Text(friend.name),
                        subtitle: Text(friend.online ? 'Online' : 'Last seen ${friend.lastSeen.hour}:${friend.lastSeen.minute}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () => _openChat(friend.name),
                              child: const Text('Message'),
                            ),
                          ],
                        ),
                      );
                    },
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