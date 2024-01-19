import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instreet/models/reviewModel.dart';

class ReviewProvider extends ChangeNotifier {
  List<ReviewModel> _Reviews = [];
  List<ReviewModel> get Reviews => _Reviews;

  Future<void> fetchReviews(String uid) async {
    try {
      var reviewCollection = FirebaseFirestore.instance.collection('users').doc(uid).collection('Reviews');
      var querySnapshot = await reviewCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        _Reviews = querySnapshot.docs
            .map((doc) => ReviewModel.fromFirestore(doc))
            .toList();
      } else {
        _Reviews = [];
      }
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addReview(ReviewModel review, String uid) async {
    try {
      CollectionReference reviews =
          FirebaseFirestore.instance.collection('users').doc(uid).collection('Reviews');
      DocumentReference documentRef = reviews.doc();

      await documentRef.set({
        'StallId': review.sid,
        'Review': review.review,
        'Rating': review.rating,
      });

      review.rid = documentRef.id;
      _Reviews.add(review);

      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }
}
