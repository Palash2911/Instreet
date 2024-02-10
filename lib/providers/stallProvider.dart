import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/constants.dart';
import '../models/stallModel.dart';

class StallProvider extends ChangeNotifier {
  List<Stall> _stalls = [];

  Future<void> addStall(Stall stall, List<dynamic> preSI, List<dynamic> preMI,
      String type) async {
    try {
      var stallRef;
      var docRef;
      List<dynamic> preSICopy = List<dynamic>.from(preSI);
      List<dynamic> preMICopy = List<dynamic>.from(preMI);

      if (type == 'add') {
        stallRef = FirebaseFirestore.instance.collection('stalls');
        docRef = stallRef.doc();
      } else {
        stallRef = FirebaseFirestore.instance.collection('stalls');
        docRef = stallRef.doc(stall.sId);
        await updateImages(stall.stallImages, stall.sId, 'StallImages');
        await updateImages(stall.menuImages, stall.sId, 'MenuImages');
        stall.stallImages.clear();
        stall.menuImages.clear();
      }

      for (var image in preSICopy) {
        if (image is String) {
          stall.stallImages.add(image);
        } else {
          String si = await uploadStallImages(image, docRef.id, 'StallImages');
          stall.stallImages.add(si);
        }
      }

      for (var image in preMICopy) {
        if (image is String) {
          stall.menuImages.add(image);
        } else {
          String mi = await uploadStallImages(image, docRef.id, 'MenuImages');
          stall.menuImages.add(mi);
        }
      }

      stall.bannerImageUrl =
          stall.stallImages.isNotEmpty ? stall.stallImages[0] : "";

      await docRef.set({
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
        'isOwner': stall.isOwner,
      });

      stall.sId = docRef.id;
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
      deleteImages(sId, 'MenuImages');
      deleteImages(sId, 'StallImages');
      _stalls.removeWhere((stall) => stall.sId == sId);
      await documentReference.delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteImages(String sId, String type) async {
    String path = 'Stalls/$sId/$type';
    final storageRef = FirebaseStorage.instance.ref().child(path);
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      await item.delete();
    }
  }

  Future<void> updateImages(
      List<dynamic> demoUrl, String sId, String type) async {
    String path = 'Stalls/$sId/$type';
    final storageRef = FirebaseStorage.instance.ref().child(path);
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      var url = await item.getDownloadURL();
      if (!demoUrl.contains(url)) {
        await item.delete();
      }
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
