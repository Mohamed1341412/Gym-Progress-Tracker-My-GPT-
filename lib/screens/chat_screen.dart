import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String friendName;
  const ChatScreen({Key? key, required this.friendName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock chat history – in a real app this would come from a backend
    final messages = <_Message>[ // newest last
      _Message(sender: friendName, text: 'Hey, ready for the gym today?'),
      _Message(sender: 'You', text: 'Absolutely! What time?'),
      _Message(sender: friendName, text: 'Thinking 6 PM works for me.'),
      _Message(sender: 'You', text: "Perfect, let's do it!"),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(friendName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.sender == 'You';
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.blueAccent.shade100
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg.text),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: false, // disabled – mock only
                    decoration: InputDecoration(
                      hintText: 'Type a message… (mock)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sending is disabled in mock')),
                    );
                  },
                ),
              ],
            ),
          ),
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