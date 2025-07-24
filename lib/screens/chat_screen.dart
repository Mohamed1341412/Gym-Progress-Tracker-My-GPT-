import 'package:flutter/material.dart';
import '../models/friend_model.dart';
import '../services/mock_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'dart:io';
import '../services/chat_service.dart';
import '../models/chat_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String friendName;
  const ChatScreen({Key? key, required this.friendName}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  Friend? _friend;
  bool _showEmoji = false;
  final _picker = ImagePicker();
  late ChatService _chatService;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _friend = MockDatabase.friends.firstWhere((f)=>f.name==widget.friendName, orElse: ()=> Friend(name: widget.friendName, countryCode: 'US'));
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'mockUser';
    _chatService = ChatService(uid);
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _chatService.sendText(widget.friendName, text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
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
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.messagesStream(widget.friendName),
              builder: (context, snapshot){
                final msgs = snapshot.data ?? [];
                WidgetsBinding.instance.addPostFrameCallback((_)=> _scrollToBottom());
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: msgs.length,
                  itemBuilder: (context, index){
                    final msg = msgs[index];
                    final isUser = msg.senderUid == FirebaseAuth.instance.currentUser?.uid;
                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blueAccent : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            if(msg.text!=null) Text(msg.text!, style: TextStyle(color: isUser?Colors.white:Colors.black87)),
                            if(msg.imageUrl!=null) Padding(padding: const EdgeInsets.only(top:4), child: Image.file(File(msg.imageUrl!), width:150)),
                          ]
                        ),
                      ),
                      if(isUser) Icon(_statusIcon(msg.status), size:14, color: Colors.grey[600]),
                    );
                  },
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
      _chatService.sendImage(widget.friendName, File(x.path));
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