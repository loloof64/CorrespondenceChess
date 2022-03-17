import 'package:correspondence_chess/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

final errorRegex = RegExp(r"\[firebase_auth/(.*)\](.*)");

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFromFirebase(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  String _authExceptionToMessage(
      {required Object exception, required BuildContext context}) {
    final message = exception.toString();
    final match = errorRegex.firstMatch(message);
    final type = match?.group(1);
    final detail = match?.group(2)?.trim();
    if (type == null || detail == null) return message;
    switch (type) {
      case 'invalid-email':
        return FlutterI18n.translate(
          context,
          'firebase.errors.invalid_email',
        );
      case 'user-not-found':
        return FlutterI18n.translate(context, 'firebase.errors.not_registered');
      case 'weak-password':
        return FlutterI18n.translate(context, 'firebase.errors.weak_password');
      case 'email-already-in-use':
        return FlutterI18n.translate(
            context, 'firebase.errors.already_registered_user');
      case 'wrong-password':
        return FlutterI18n.translate(context, 'firebase.errors.wrong_password');
      case 'unknown':
        switch (detail) {
          case 'Given String is empty or null':
            return FlutterI18n.translate(
              context,
              'firebase.errors.empty_field',
            );
          default:
            return message;
        }
      default:
        return message;
    }
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signInWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user);
    } catch (exception) {
      return _authExceptionToMessage(exception: exception, context: context);
    }
  }

  Future registerWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // TODO store new user in Firestore

      return _userFromFirebase(user);
    } catch (exception) {
      return _authExceptionToMessage(exception: exception, context: context);
    }
  }

  Future signOut({required BuildContext context}) async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      return _authExceptionToMessage(exception: exception, context: context);
    }
  }
}
