import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class DBService {
  getUserByDisplayName(String displayName) async {
    return await authService
        .getDB()
        .collection('users')
        .where('displayName', isEqualTo: displayName)
        .get();
  }

  getUserByEmail(String email) async {
    return await authService
        .getDB()
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  String getUserNameFromEmail(String email, snapshot) {
    final QuerySnapshot snapshot = dbService.getUserByEmail(email);
    return (snapshot.docs[0].data() as dynamic)['displayName'];
  }

  void updateUserData(User? user) async {
    DocumentReference ref =
        authService.getDB().collection('users').doc(user!.uid);
    return ref.set(
      {
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoURL,
        'displayName':
            (user.displayName != null) ? user.displayName : user.email,
        'lastSeen': DateTime.now(),
      },
      SetOptions(merge: true),
    );
  }

  createChat(String chatID, List<String?> chatBetween) {
    authService.getDB().collection('chats').doc(chatID).set({
      'chatID': chatID,
      'users': chatBetween,
    });
  }

  sendMessage(String chatID, String message) {
    Map<String, dynamic> messageMap = {
      'message': message,
      'from': authService.getCurrentUserName() as String,
      'fromEmail': authService.getCurrentEmail() as String,
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    authService
        .getDB()
        .collection('chats')
        .doc(chatID)
        .collection('convo')
        .add(messageMap);
  }

  getConvo(chatID) async {
    return await authService
        .getDB()
        .collection('chats')
        .doc(chatID)
        .collection('convo')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChats(String? email) async {
    return await authService
        .getDB()
        .collection('chats')
        .where('users', arrayContains: email)
        .snapshots();
  }
}

final DBService dbService = DBService();
