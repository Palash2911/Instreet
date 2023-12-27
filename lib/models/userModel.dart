class UserModel {
  final String uid;
  final String uName;
  final String uEmail;
  final String phoneNo;
  final String dob;
  final String gender;
  final DateTime createdAt;
  final List<dynamic> favorites;

  UserModel({
    required this.uid,
    required this.uName,
    required this.uEmail,
    required this.phoneNo,
    required this.dob,
    required this.gender,
    required this.createdAt,
    required this.favorites,
  });

  void toggleFavorite(String stallId) {
    if (favorites.contains(stallId)) {
      favorites.remove(stallId);
    } else {
      favorites.add(stallId);
    }
  }
}
