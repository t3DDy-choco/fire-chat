import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class DBService {
  getUserByEmail(String email) async {
    return await authService
        .getDB()
        .collection('users')
        .where('email', isEqualTo: email)
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
}

final DBService dbService = DBService();
