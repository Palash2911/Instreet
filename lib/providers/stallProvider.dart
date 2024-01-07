import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instreet/models/userModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:provider/provider.dart';
import '../models/stallModel.dart';

class StallProvider extends ChangeNotifier {
  
  List<Stall> _stalls = [];
  List<Stall> get stalls => _stalls;

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
}
