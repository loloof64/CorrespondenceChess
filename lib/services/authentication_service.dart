import 'package:correspondence_chess/models/user.dart';
import 'package:correspondence_chess/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SimpleUserData? _userFromFirebase(User? user) {
    return user != null
        ? SimpleUserData(uid: user.uid, email: user.email!)
        : null;
  }

  String _authExceptionToMessage(
      {required FirebaseAuthException exception,
      required BuildContext context}) {
    final String detail = exception.message ?? '';
    switch (exception.code) {
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
            return detail;
        }
      default:
        return detail;
    }
  }

  Stream<SimpleUserData?> get user {
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
    } on FirebaseAuthException catch (exception) {
      return _authExceptionToMessage(exception: exception, context: context);
    }
  }

  Future registerWithEmailAndPassword(
      {required String email,
      required String password,
      required String pseudonym,
      required BuildContext context}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;

      await SingleUserDatabaseService(uid: user.uid).saveUser(
        email: user.email!,
        pseudonym: pseudonym,
      );

      return _userFromFirebase(user);
    } on FirebaseAuthException catch (exception) {
      return _authExceptionToMessage(exception: exception, context: context);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (exception) {
      return exception.message;
    }
  }
}
