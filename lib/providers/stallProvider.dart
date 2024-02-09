import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/constants.dart';
import '../models/stallModel.dart';

class StallProvider extends ChangeNotifier {
  List<Stall> _stalls = [];

  Future<void> addStall(Stall stall, List<File> preSI, List<File> preMI) async {
    try {
      CollectionReference stallref =
          FirebaseFirestore.instance.collection('stalls');

      DocumentReference documentRef = stallref.doc();
      for (File image in preSI) {
        String si =
            await uploadStallImages(image, documentRef.id, 'StallImages');
        stall.stallImages.add(si);
      }

      for (File image in preMI) {
        String mi =
            await uploadStallImages(image, documentRef.id, 'MenuImages');
        stall.menuImages.add(mi);
      }

      stall.bannerImageUrl =
          stall.stallImages.isNotEmpty ? stall.stallImages[0] : "";

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

  Future<void> deleteStall(String sId) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('stalls').doc(sId);
      String folderPath = 'Stalls/$sId/MenuImages/';
      String folderPath2 = 'Stalls/$sId/StallImages/';
      final storageRef = FirebaseStorage.instance.ref().child(folderPath);
      final listResult = await storageRef.listAll();
      for (var item in listResult.items) {
        await item.delete();
      }
      final storageRef2 = FirebaseStorage.instance.ref().child(folderPath2);
      final listResult2 = await storageRef2.listAll();
      for (var item in listResult2.items) {
        await item.delete();
      }
      _stalls.removeWhere((stall) => stall.sId == sId);
      await documentReference.delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String> uploadStallImages(File image, String sId, String type) async {
    try {
      String imageType = image.path.split('.').last;

      var storage = FirebaseStorage.instance.ref().child(
          'Stalls/$sId/$type/${DateTime.now().millisecondsSinceEpoch}.$imageType');

      var metadata = SettableMetadata(
        contentType: 'image/$imageType',
      );

      TaskSnapshot taskSnapshot = await storage.putFile(image, metadata);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error uploading image: $e",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    return '';
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
        var stallDoc =
            FirebaseFirestore.instance.collection('stalls').doc(stallId);
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

  List<Stall> getCategoryStalls(String category, String uid) {
    return _stalls
        .where((stall) =>
            stall.stallCategories.contains(category) && stall.creatorUID != uid)
        .toList();
  }

  List<Stall> getUserRegisteredStalls(String uid) {
    return _stalls.where((stall) => stall.creatorUID == uid).toList();
  }

  List<Stall> getAllStalls(String uid) {
    return _stalls.where((stall) => stall.creatorUID != uid).toList();
  }

  List<Stall> getSearchStalls(String query, String uid) {
    return _stalls = _stalls
        .where((stall) =>
            stall.stallName.toLowerCase().contains(query.toLowerCase()) &&
            stall.creatorUID != uid)
        .toList();
  }
}
