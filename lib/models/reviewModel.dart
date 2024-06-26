import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String rid;
  final String sid;
  final String review;
  final double rating;
  final String uid;
  final String userName;

  ReviewModel({
    required this.rid,
    required this.sid,
    required this.review,
    required this.rating,
    required this.uid,
    required this.userName,
  });

  ReviewModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc)
      : rid = doc.id,
        sid = doc['stallId'].toString(),
        review = doc['review'].toString(),
        uid = doc['uid'].toString(),
        userName = doc['userName'].toString(),
        rating = doc['rating'].toDouble();
}
