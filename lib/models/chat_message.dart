import 'package:cloud_firestore/cloud_firestore.dart';

enum MsgStatus { sent, delivered, read }

class ChatMessage {
  String id;
  String senderUid;
  String? text;
  String? imageUrl;
  MsgStatus status;
  DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderUid,
    this.text,
    this.imageUrl,
    this.status = MsgStatus.sent,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'senderUid': senderUid,
        'text': text,
        'imageUrl': imageUrl,
        'status': status.index,
        'timestamp': Timestamp.fromDate(timestamp),
      };

  factory ChatMessage.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderUid: d['senderUid'],
      text: d['text'],
      imageUrl: d['imageUrl'],
      status: MsgStatus.values[d['status'] ?? 0],
      timestamp: (d['timestamp'] as Timestamp).toDate(),
    );
  }
} 