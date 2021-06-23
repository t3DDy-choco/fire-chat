import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late Stream<User?> user;
  late Stream<Map<String, dynamic>?> profile;
  PublishSubject loading = PublishSubject();

  AuthService() {
    user = _auth.authStateChanges();
    profile = user.switchMap((User? u) {
      if (u != null) {
        return _db
            .collection('users')
            .doc(u.uid)
            .snapshots()
            .map((snap) => snap.data());
      } else {
        return Stream.empty();
      }
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> googleSignIn(String email, String password) async {
    loading.add(true);
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    User? user = authResult.user;

    updateUserData(user);
    print('Signed in ' + user!.displayName.toString());
    loading.add(false);
    return true;
  }

  Future<bool> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('Email is already in use.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void updateUserData(User? user) async {
    DocumentReference ref = _db.collection('users').doc(user!.uid);
    return ref.set(
      {
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoURL,
        'displayName': user.displayName,
        'lastSeen': DateTime.now(),
      },
      SetOptions(merge: true),
    );
  }

  void signOut() {
    _auth.signOut();
  }
}

final AuthService authService = AuthService();
