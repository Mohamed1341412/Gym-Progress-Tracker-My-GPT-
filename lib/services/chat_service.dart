import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';

class ChatService {
  final String currentUid;
  ChatService(this.currentUid);

  String _chatId(String otherUid) {
    final ids = [currentUid, otherUid]..sort();
    return ids.join('_');
  }

  Stream<List<ChatMessage>> messagesStream(String otherUid) {
    final chatId = _chatId(otherUid);
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snap) => snap.docs.map(ChatMessage.fromDoc).toList());
  }

  Future<void> sendText(String otherUid, String text) async {
    final chatId = _chatId(otherUid);
    final msg = ChatMessage(
      id: const Uuid().v4(),
      senderUid: currentUid,
      text: text,
      timestamp: DateTime.now(),
    );
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(msg.id)
        .set(msg.toMap());
  }

  Future<void> sendImage(String otherUid, File img) async {
    final fileName = '${const Uuid().v4()}.jpg';
    final ref = FirebaseStorage.instance.ref('chatImages/$fileName');
    await ref.putFile(img, SettableMetadata(contentType: 'image/jpeg'));
    final url = await ref.getDownloadURL();
    final chatId = _chatId(otherUid);
    final msg = ChatMessage(
      id: const Uuid().v4(),
      senderUid: currentUid,
      imageUrl: url,
      timestamp: DateTime.now(),
    );
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(msg.id)
        .set(msg.toMap());
  }

  Future<void> markRead(String otherUid) async {
    final chatId = _chatId(otherUid);
    final snap = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('status', isEqualTo: MsgStatus.delivered.index)
        .get();
    for (final d in snap.docs) {
      d.reference.update({'status': MsgStatus.read.index});
    }
  }
} 