class SimpleUserData {
  final String uid;
  final String email;

  SimpleUserData({
    required this.uid,
    required this.email,
  });
}

class CompleteUserData {
  final String uid;
  final String email;
  final String pseudonym;

  CompleteUserData({
    required this.uid,
    required this.email,
    required this.pseudonym,
  });
}
