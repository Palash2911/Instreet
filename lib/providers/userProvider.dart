import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instreet/models/userModel.dart';
import 'package:instreet/providers/notificationProvider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {


  Future updateToken(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    var fcmt = await FirebaseNotification().getToken();
    try {
      CollectionReference users =FirebaseFirestore.instance.collection('users');
      await users.doc(uid).update({"FcmToken": fcmt.toString()});
      prefs.setString("FCMT", fcmt.toString());
      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
  }

  Future registerUser(UserModel user) async {

    final prefs = await SharedPreferences.getInstance();
    
    try {
      CollectionReference users =FirebaseFirestore.instance.collection('users');

      await users.doc(user.uid).set({
        'Name': user.uName,
        "CreatedAt": user.createdAt,
        "PhoneNo": user.phoneNo,
        "UID": user.uid,
        "Email": user.uEmail,
        "Gender": user.gender,
        "DOB": user.dob,
        "Creator": user.isCreator,
      });
      
      prefs.setString("UserName", user.uName);
      prefs.setBool("IsCreator", user.isCreator);
      prefs.setString("JDate", DateFormat("dd MMM, yyyy").format(user.createdAt));
      updateToken(user.uid);
      notifyListeners();
    } catch (e) {
      prefs.setString("UserName", "");
      notifyListeners();
      rethrow;
    }
  }

  Future getUser(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        return userSnapshot;
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception("Failed to fetch user data");
    }
  }


  Future updateUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      CollectionReference users =FirebaseFirestore.instance.collection('users');
      await users.doc(user.uid).update({
        'Name': user.uName,
        "CreatedAt": user.createdAt,
        "PhoneNo": user.phoneNo,
        "UID": user.uid,
        "Email": user.uEmail,
        "Gender": user.gender,
        "DOB": user.dob,
        "Creator": user.isCreator,
      });
      prefs.setString("UserName", user.uName);
      prefs.setBool("IsCreator", user.isCreator);
      prefs.setString("JDate", DateFormat("dd MMM, yyyy").format(user.createdAt));
      notifyListeners();
    } catch (e) {
      prefs.setString("UserName", "");
      notifyListeners();
      rethrow;
    }
  }
}
