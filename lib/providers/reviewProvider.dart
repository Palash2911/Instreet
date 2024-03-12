import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instreet/models/reviewModel.dart';

class ReviewProvider extends ChangeNotifier {
  List<ReviewModel> _allReviews = [];
  List<ReviewModel> get allReviews => _allReviews;

  Future<void> fetchReviews() async {
    try {
      var reviewCollection = FirebaseFirestore.instance.collection('reviews');
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

  Future<void> addReview(ReviewModel review) async {
    try {
      CollectionReference reviews =
          FirebaseFirestore.instance.collection('reviews');
      DocumentReference documentRef = reviews.doc();

      await documentRef.set({
        'stallId': review.sid,
        'review': review.review,
        'rating': review.rating,
        'uid': review.uid,
        'userName': review.userName,
      });

      review.rid = documentRef.id;
      _allReviews.add(review);

      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteReviews(String sId) async {
    try {
      CollectionReference reviewRef =FirebaseFirestore.instance.collection('reviews');
      var querySnapshot = await reviewRef.where('stallId', isEqualTo: sId).get();
      for (var doc in querySnapshot.docs) {
        await reviewRef.doc(doc.id).delete();
      }
      _allReviews.removeWhere((review) => review.sid == sId);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  List<ReviewModel> getStallReview(String sId) {
    return _allReviews.where((review) => review.sid == sId).toList();
  }


  // delete function to delete review
  Future<void> deleteReview(String reviewId,String currentUid) async {
    try {
      CollectionReference reviewRef = FirebaseFirestore.instance.collection('reviews');
      await reviewRef.doc(reviewId).delete();
      _allReviews.removeWhere((review) => review.rid == reviewId && review.uid==currentUid);
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }


}
