import 'dart:io';

class Stall {
  final String sId;
  final String ownerName;
  final double rating;
  final List<dynamic> stallCategories;
  final String stallDescription;
  final String stallName;
  String bannerImageUrl;

  Stall({
    required this.sId,
    required this.stallName,
    required this.ownerName,
    required this.rating,
    required this.stallCategories,
    required this.stallDescription,
    required this.bannerImageUrl,
  });
}
