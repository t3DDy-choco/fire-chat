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
    authService.getDB().collection('chats').doc('chatID').set({
      'chatID': chatID,
      'users': chatBetween,
    });
  }
}

final DBService dbService = DBService();
