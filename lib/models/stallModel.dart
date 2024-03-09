import 'package:cloud_firestore/cloud_firestore.dart';

class Stall {
  String sId;
  final String ownerName;
  double rating;
  final List<dynamic> stallCategories;
  final String stallDescription;
  final String stallName;
  String bannerImageUrl;
  final List<dynamic> favoriteUsers;
  final String ownerContact;
  final String location;
  final List<dynamic> stallImages;
  final List<dynamic> menuImages;
  final String creatorUID;
  final bool isOwner;
  final bool isTrending;

  Stall({
    required this.sId,
    required this.stallName,
    required this.ownerName,
    required this.rating,
    required this.stallCategories,
    required this.stallDescription,
    required this.bannerImageUrl,
    required this.favoriteUsers,
    required this.ownerContact,
    required this.location,
    required this.stallImages,
    required this.menuImages,
    required this.creatorUID,
    required this.isOwner,
    required this.isTrending,
  });

  Stall.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc)
      : sId = doc.id,
        stallName = doc['stallName'],
        ownerName = doc['ownerName'],
        rating = doc['rating'].toDouble(),
        stallCategories = doc['stallCategory'],
        stallDescription = doc['stallDescription'],
        bannerImageUrl = doc['bannerImage'],
        ownerContact = doc['ownerContact'],
        location = doc['location'],
        stallImages = doc['stallImages'],
        creatorUID = doc['creatorUID'],
        menuImages = doc['menuImages'],
        isOwner = doc['isOwner'],
        isTrending = doc['isTrending'],
        favoriteUsers = doc['favoriteUsers'];
}
