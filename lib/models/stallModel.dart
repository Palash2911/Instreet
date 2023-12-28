import 'package:cloud_firestore/cloud_firestore.dart';

class Stall {
  final String sId;
  final String ownerName;
  final double rating;
  final List<dynamic> stallCategories;
  final String stallDescription;
  final String stallName;
  String bannerImageUrl;
  final List<dynamic> favoriteUsers;

  Stall({
    required this.sId,
    required this.stallName,
    required this.ownerName,
    required this.rating,
    required this.stallCategories,
    required this.stallDescription,
    required this.bannerImageUrl,
    required this.favoriteUsers,
  });

  Stall.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc)
      : sId = doc.id,
        stallName = doc['stallName'],
        ownerName = doc['ownerName'],
        rating = doc['rating'].toDouble(),
        stallCategories = doc['stallCategory'],
        stallDescription = doc['stallDescription'],
        bannerImageUrl = doc['bannerImage'],
        favoriteUsers = doc['favoriteUsers'];
}
