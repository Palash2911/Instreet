import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instreet/models/reviewModel.dart';

class ReviewProvider extends ChangeNotifier {
  List<ReviewModel> _allReviews = [];
  List<ReviewModel> get allReviews => _allReviews;

  Future<void> fetchReviews(String uid) async {
    try {
      var reviewCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('reviews');
      var querySnapshot = await reviewCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        _allReviews = querySnapshot.docs
            .map((doc) => ReviewModel.fromFirestore(doc))
            .toList();
      } else {
        _allReviews = [];
      }
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addReview(ReviewModel review, String uid) async {
    try {
      CollectionReference reviews = FirebaseFirestore.instance.collection('reviews');
      DocumentReference documentRef = reviews.doc();

      await documentRef.set({
        'stallId': review.sid,
        'review': review.review,
        'rating': review.rating,
        'uid': review.uid,
      });

      review.rid = documentRef.id;
      _allReviews.add(review);

      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }
}
