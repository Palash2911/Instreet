import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instreet/models/userModel.dart';

class UserProvider extends ChangeNotifier {
  Future getUser(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (userSnapshot.exists) {
        return userSnapshot;
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception("Failed to fetch user data");
    }
  }

}
