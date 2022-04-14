import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controller/authenticate_to_firebase.dart';
import '../firebase_options.dart';

import '../view/let_us_chat.dart';

class StateOfApplication extends ChangeNotifier {
  StateOfApplication() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = UserStatus.loggedIn;
        _chatBookSubscription = FirebaseFirestore.instance
            .collection('chatbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _chatBookMessages = [];
          for (final document in snapshot.docs) {
            _chatBookMessages.add(
              LetUsChatMessage(
                name: document.data()['name'] as String,
                message: document.data()['text'] as String,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        _loginState = UserStatus.loggedOut;
        _chatBookMessages = [];
      }
      notifyListeners();
    });
  }

  UserStatus _loginState = UserStatus.loggedOut;
  UserStatus get loginState => _loginState;

  String? _email;
  String? get email => _email;

  StreamSubscription<QuerySnapshot>? _chatBookSubscription;
  StreamSubscription<QuerySnapshot>? get chatBookSubscription =>
      _chatBookSubscription;
  List<LetUsChatMessage> _chatBookMessages = [];
  List<LetUsChatMessage> get chatBookMessages => _chatBookMessages;

  void startLoginFlow() {
    _loginState = UserStatus.emailAddress;
    notifyListeners();
  }

  Future<void> verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = UserStatus.password;
      } else {
        _loginState = UserStatus.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = UserStatus.emailAddress;
    notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<DocumentReference> addMessageToChatBook(String message) {
    if (_loginState != UserStatus.loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('chatbook')
        .add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
