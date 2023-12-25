import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/stallModel.dart';

class StallProvider extends ChangeNotifier {
  // Future registerStall(Stall stall) async {
  //   try {
  //     var storage = FirebaseStorage.instance;
  //     String filePath = 'Stalls/BannerImages/${stall.bannerImageUrl}'; // Replace with your file path
  //     var ref = storage.ref().child(filePath);
  //
  //     stall.bannerImageUrl = await ref.getDownloadURL();
  //     CollectionReference stalls =
  //     FirebaseFirestore.instance.collection('stalls');
  //     await stalls.doc().set({
  //       'stallName': stall.stallName,
  //       'stallDescription': stall.stallDescription,
  //       "ownerName": stall.ownerName,
  //       "stallCategory": stall.stallCategories,
  //       "bannerImage": stall.bannerImageUrl,
  //       "rating": stall.rating,
  //     });
  //     notifyListeners();
  //   } catch (e) {
  //     notifyListeners();
  //     rethrow;
  //   }
  // }
  //
  // Future updateStall(Stall stall) async {
  //
  // }
}
