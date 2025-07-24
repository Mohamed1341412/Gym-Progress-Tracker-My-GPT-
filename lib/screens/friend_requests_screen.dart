import 'package:flutter/material.dart';
import '../services/friend_service.dart';
import '../models/friend_model.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({Key? key}) : super(key: key);

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final service = FriendService();

  void _accept(String uid) {
    service.acceptRequest(uid);
  }

  void _decline(String uid) {
    service.rejectRequest(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friend Requests')),
      body: StreamBuilder<List<Friend>>(
        stream: service.requestsStream(),
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          final reqs = snapshot.data ?? [];
          if(reqs.isEmpty){
            return const Center(child: Text('No pending requests'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reqs.length,
            itemBuilder: (context, index){
              final fr = reqs[index];
          return Card(
            child: ListTile(
              leading: Text(fr.flagEmoji, style: const TextStyle(fontSize: 24)),
              title: Text(fr.name),
              subtitle: const Text('wants to be your friend'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _accept(fr.uid),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _decline(fr.uid),
                  ),
                ],
              ),
            ),
          );
            },
          );
        },
      ),
    );
  }
} 