import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/friend_model.dart';

class FriendService {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _coll => FirebaseFirestore.instance.collection('friends').doc(uid).collection('list');

  Stream<List<Friend>> friendsStream() => _coll.where('status', isEqualTo: FriendStatus.accepted.index).snapshots().map((s)=> s.docs.map(Friend.fromDoc).toList());

  Stream<List<Friend>> requestsStream() => _coll.where('status', isEqualTo: FriendStatus.pending.index).snapshots().map((s)=> s.docs.map(Friend.fromDoc).toList());

  Future<void> sendRequest(Friend target) async {
    final myInfo = Friend(uid: uid, name: FirebaseAuth.instance.currentUser!.displayName??'User', countryCode: 'US', status: FriendStatus.pending);
    await _coll.doc(target.uid).set(target.toMap());
    await FirebaseFirestore.instance.collection('friends').doc(target.uid).collection('list').doc(uid).set(myInfo.toMap());
  }

  Future<void> acceptRequest(String otherUid) async {
    await _updateStatus(otherUid, FriendStatus.accepted);
  }

  Future<void> rejectRequest(String otherUid) async {
    await _coll.doc(otherUid).delete();
  }

  Future<void> block(String otherUid) async => _updateStatus(otherUid, FriendStatus.blocked);

  Future<void> _updateStatus(String otherUid, FriendStatus status) async {
    await _coll.doc(otherUid).update({'status': status.index});
    await FirebaseFirestore.instance.collection('friends').doc(otherUid).collection('list').doc(uid).update({'status': status.index});
  }
} 