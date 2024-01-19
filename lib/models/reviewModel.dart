import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String rid;
  final String sid;
  final String review;
  final double rating;

  ReviewModel({
    required this.rid,
    required this.sid,
    required this.review,
    required this.rating,
  });

  ReviewModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc)
      : rid = doc.id,
        sid = doc['StallId'].toString(),
        review = doc['Review'].toString(),
        rating = doc['Rating'].toDouble();
}
