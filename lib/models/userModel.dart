class UserModel {
  final String uid;
  final List<dynamic> favorites;

  UserModel({required this.uid, required this.favorites});

  void toggleFavorite(String stallId) {
    if (favorites.contains(stallId)) {
      favorites.remove(stallId);
    } else {
      favorites.add(stallId);
    }
  }
}