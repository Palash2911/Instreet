class UserModel {
  final String uid;
  final String uName;
  final String uEmail;
  final String phoneNo;
  final String dob;
  final String gender;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.uName,
    required this.uEmail,
    required this.phoneNo,
    required this.dob,
    required this.gender,
    required this.createdAt,
  });
}
