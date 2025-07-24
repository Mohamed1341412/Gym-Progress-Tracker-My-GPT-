import 'package:flutter/material.dart';
import '../models/friend_model.dart';
import '../services/mock_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'dart:io';

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
  bool _showEmoji = false;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _friend = MockDatabase.friends.firstWhere((f)=>f.name==widget.friendName, orElse: ()=> Friend(name: widget.friendName, countryCode: 'US'));
    _messages = [
      _Message(sender: 'friend', text: 'Hey, ready for the gym today?', status: MsgStatus.read),
      _Message(sender: 'me', text: 'Sure! Let\'s do it.', status: MsgStatus.read),
    ];
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(sender: 'me', text: text));
    });
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final double itemHeight = 50; // Approximate height of a message bubble
        final double listHeight = MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom -
            200; // Subtract padding and space for input field
        final double offset = _messages.length * itemHeight;
        if (offset > listHeight) {
          _scrollController.animateTo(offset,
              duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        }
      }
    });
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        if(msg.text!=null) Text(msg.text!, style: TextStyle(color: isMe?Colors.white:Colors.black87)),
                        if(msg.imageUrl!=null) Padding(padding: const EdgeInsets.only(top:4), child: Image.file(File(msg.imageUrl!), width:150)),
                      ]
                    ),
                  ),
                  if(isMe) Icon(_statusIcon(msg.status), size:14, color: Colors.grey[600]),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.emoji_emotions), onPressed: ()=> setState(()=> _showEmoji=!_showEmoji)),
                  IconButton(icon: const Icon(Icons.attach_file), onPressed: _pickImage),
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
          ),
          if(_showEmoji)
            SizedBox(
              height: 250,
              child: EmojiPicker(onEmojiSelected: (c, e){ _controller.text += e.emoji; }),
            ),
        ],
      ),
    );
  }

  IconData _statusIcon(MsgStatus s){
    switch(s){
      case MsgStatus.sent: return Icons.check;
      case MsgStatus.delivered: return Icons.done_all;
      case MsgStatus.read: return Icons.done_all; // could color differently
    }
  }

  void _pickImage() async {
    final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if(x==null) return;
    setState(() {
      _messages.add(_Message(sender:'me', imageUrl: x.path));
    });
    _scrollToBottom();
  }
}

enum MsgStatus { sent, delivered, read }

class _Message {
  final String sender;
  final String? text;
  final String? imageUrl;
  MsgStatus status;
  _Message({required this.sender, this.text, this.imageUrl, this.status = MsgStatus.sent});
} 