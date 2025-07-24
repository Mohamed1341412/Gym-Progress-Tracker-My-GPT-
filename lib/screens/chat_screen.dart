import 'package:flutter/material.dart';
import '../models/friend_model.dart';
import '../services/mock_database.dart';

class ChatScreen extends StatefulWidget {
  final String friendName;
  const ChatScreen({Key? key, required this.friendName}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<_Message> _messages;
  final TextEditingController _controller = TextEditingController();
  Friend? _friend;

  @override
  void initState() {
    super.initState();
    _friend = MockDatabase.friends.firstWhere((f)=>f.name==widget.friendName, orElse: ()=> Friend(name: widget.friendName, countryCode: 'US'));
    _messages = [
      _Message(sender: 'friend', text: 'Hey, ready for the gym today?'),
      _Message(sender: 'me', text: 'Sure! Let's do it.'),
    ];
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(sender: 'me', text: text));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(_friend?.flagEmoji ?? ''),
            const SizedBox(width: 6),
            Text(widget.friendName),
            if (_friend?.online == true)
              const Padding(
                padding: EdgeInsets.only(left:4),
                child: Icon(Icons.circle, size:10, color: Colors.green),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_friend?.muted==true?Icons.notifications_off:Icons.notifications),
            tooltip: 'Mute',
            onPressed: (){ setState(()=> _friend!.muted = !_friend!.muted);},
          ),
          IconButton(
            icon: const Icon(Icons.block),
            tooltip: 'Block',
            onPressed: (){ setState(()=> _friend!.blocked=true); Navigator.pop(context);},
          ),
          IconButton(
            icon: const Icon(Icons.flag),
            tooltip: 'Report',
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User reported. Thank you.')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg.sender == 'me';
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87),
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
                      decoration:
                          const InputDecoration(hintText: 'Type a message...'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Message {
  final String sender;
  final String text;
  _Message({required this.sender, required this.text});
} 