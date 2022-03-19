import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:correspondence_chess/models/user.dart';

class SingleUserDatabaseService {
  final String uid;

  SingleUserDatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveUser({
    required String email,
    required String pseudonym,
  }) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'pseudonym': pseudonym,
    });
  }

  CompleteUserData? _userFromSnapshot(DocumentSnapshot snapshot) {
    if (!(snapshot.exists)) return null;
    if (snapshot.data() == null) return null;

    final data = snapshot.data() as Map<String, dynamic>;
    return CompleteUserData(
      uid: uid,
      email: data['email'],
      pseudonym: data['pseudonym'],
    );
  }

  Stream<CompleteUserData?> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }
}

class AllUsersDatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  List<CompleteUserData?> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map(_userFromSnapshot).toList();
  }

  Stream<List<CompleteUserData?>> get users {
    return userCollection.snapshots().map(_usersListFromSnapshot);
  }

  CompleteUserData? _userFromSnapshot(DocumentSnapshot snapshot) {
    if (!(snapshot.exists)) return null;
    if (snapshot.data() == null) return null;

    final data = snapshot.data() as Map<String, dynamic>;
    return CompleteUserData(
      uid: data['uid'],
      email: data['email'],
      pseudonym: data['pseudonym'],
    );
  }

  Future<List<String>> checkForValuesAlreadyRegistered(
      Map<String, String> valuesToCheck) async {
    List<String> takenValues = [];
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    for (final doc in querySnapshot.docs) {
      for (final parameterKey in valuesToCheck.keys) {
        if (doc.data()[parameterKey] == valuesToCheck[parameterKey]) {
          takenValues.add(parameterKey);
        }
      }
    }
    return takenValues;
  }
}
