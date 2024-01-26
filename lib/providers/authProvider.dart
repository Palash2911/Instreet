import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  var _token = "";
  final _auth = FirebaseAuth.instance;
  var verificationId = '';
  final _profileCreated = false;
  var _fcmToken = "";
  var _userName = '';
  var _isCreator = false;
  var _joiningDate = '';

  bool get isAuth {
    return _auth.currentUser?.uid != null ? true : false;
  }

  String get fcmToken {
    return _fcmToken;
  }

  String get token {
    return _token;
  }

  String get userName {
    return _userName;
  }

  bool get isCreator {
    return _isCreator;
  }

  String get joiningDate {
    return _joiningDate;
  }

  Future<void> authenticate(String phoneNo) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // await _auth.signInWithCredential(credential).then((value) {});
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print("Invalid Number");
          } else {
            print(e);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    try {
      var cred = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      _token = _auth.currentUser!.uid;
      prefs.setString('UID', _auth.currentUser!.uid);
      prefs.setString("FCMT", "");
      prefs.setString("UserName", "");
      prefs.setBool("IsCreator", false);
      prefs.setString("JDate", "");
      notifyListeners();
      return cred.user != null ? true : false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future signInGoogle() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      var user = await _auth.signInWithProvider(googleAuthProvider);
      final prefs = await SharedPreferences.getInstance();
      _token = _auth.currentUser!.uid;
      prefs.setString('UID', _auth.currentUser!.uid);
      prefs.setString("FCMT", "");
      prefs.setString("UserName", "");
      prefs.setBool("IsCreator", false);
      prefs.setString("JDate", "");
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var user = true;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      await users.doc(_auth.currentUser?.uid).get().then(
            (dataSnapshot) => {
              if (!dataSnapshot.exists)
                {user = false}
              else
                {
                  prefs.setString("UserName", dataSnapshot['Name']),
                  prefs.setBool("IsCreator", dataSnapshot['Creator']),
                  prefs.setString(
                      "JDate",
                      DateFormat("dd MMM, yyyy")
                          .format(dataSnapshot['CreatedAt'].toDate())),
                }
            },
          );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear().then((value) async {
        if (value) {
          await _auth.signOut();
        }
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('UID')) {
      return;
    }
    _token = prefs.getString('UID')!;
    if (prefs.getString("FCMT") != null) {
      _fcmToken = prefs.getString("FCMT")!;
    }
    _userName = prefs.getString("UserName")!;
    _isCreator = prefs.getBool("IsCreator")!;
    _joiningDate = prefs.getString("JDate")!;
    notifyListeners();
  }
}
