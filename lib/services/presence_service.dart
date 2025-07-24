import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PresenceService {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> initialize() async {
    final userDoc = FirebaseFirestore.instance.collection('friends').doc(uid);
    await userDoc.set({'online': true, 'lastSeen': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    FirebaseFirestore.instance.runTransaction((t) async {});
    FirebaseFirestore.instance.clearPersistence();
    final conn = FirebaseFirestore.instance;
    conn.settings = const Settings(persistenceEnabled: true);
    FirebaseFirestore.instance
        .enableNetwork();
    /// onDisconnect equivalent via presence channel not direct in Firestore; use write with server timestamp every few minutes or rely on Cloud Functions.
  }
} 