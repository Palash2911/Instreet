import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stallModel.dart';

class StallProvider extends ChangeNotifier {
  
  List<Stall> _stalls = [];
  List<Stall> get stalls => _stalls;

  Future<void> addStall(Stall stall) async {
    try {

      // Add Images to Firebase Logic Left

      CollectionReference stallref = FirebaseFirestore.instance.collection('stalls');

      DocumentReference documentRef = stallref.doc();

      await documentRef.set({
        'stallName': stall.stallName,
        'ownerName': stall.ownerName,
        'rating': stall.rating,
        'stallCategory': stall.stallCategories,
        'stallDescription': stall.stallDescription,
        'bannerImage': stall.bannerImageUrl,
        'ownerContact': stall.ownerContact,
        'location': stall.location,
        'stallImages': stall.stallImages,
        'creatorUID': stall.creatorUID,
        'menuImages': stall.menuImages,
        'favoriteUsers': stall.favoriteUsers,
      });

      stall.sId = documentRef.id;
      _stalls.add(stall);

      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  Future getStall(String sId) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('stalls').doc(sId).get();
      if (userSnapshot.exists) {
        return userSnapshot;
      } else {
        throw Exception("Stall not found");
      }
    } catch (e) {
      throw Exception("Failed to fetch stall data");
    }
  }

   Future updateStall(Stall stall) async {

    try {
      String sId = stall.sId;
      
      CollectionReference users =
          FirebaseFirestore.instance.collection('stalls');
      await users.doc(sId).update({
        'stallName': stall.stallName,
        'ownerName': stall.ownerName,
        'rating': stall.rating,
        'stallCategory': stall.stallCategories,
        'stallDescription': stall.stallDescription,
        'bannerImage': stall.bannerImageUrl,
        'ownerContact': stall.ownerContact,
        'location': stall.location,
        'stallImages': stall.stallImages,
        'creatorUID': stall.creatorUID,
        'menuImages': stall.menuImages,
        'favoriteUsers': stall.favoriteUsers,
      });
      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchStalls() async {
    var stallCollection = FirebaseFirestore.instance.collection('stalls');
    var querySnapshot = await stallCollection.get();
    _stalls =
        querySnapshot.docs.map((doc) => Stall.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(String stallId, String uid) async {
    if (uid.isEmpty) return;
    var stallIndex = _stalls.indexWhere((stall) => stall.sId == stallId);
    if (stallIndex != -1 && uid.isNotEmpty) {
      if (_stalls[stallIndex].favoriteUsers.contains(uid)) {
        _stalls[stallIndex].favoriteUsers.remove(uid);
      } else {
        _stalls[stallIndex].favoriteUsers.add(uid);
      }
      notifyListeners();
      try {
        var stallDoc =FirebaseFirestore.instance.collection('stalls').doc(stallId);
        await stallDoc
            .update({'favoriteUsers': _stalls[stallIndex].favoriteUsers});
      } catch (e) {
        print(e);
        rethrow;
      }
    }
  }

  List<Stall> getFavoriteStalls(String uid) {
    return _stalls.where((stall) => stall.favoriteUsers.contains(uid)).toList();
  }

  List<Stall> getUserRegisteredStalls(String uid) {
    return _stalls.where((stall) => stall.creatorUID == uid).toList();
  }
}
