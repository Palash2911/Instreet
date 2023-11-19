import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends ChangeNotifier {
  var _token = "";
  final _auth = FirebaseAuth.instance;
  var verificationId = '';
  var _profileCreated = false;
  var _fcmToken = "";

  bool get isAuth {
    return _auth.currentUser?.uid != null ? true : false;
  }

  String get fcmToken {
    return _fcmToken;
  }

  bool get isProfile {
    return _profileCreated;
  }

  String get token {
    return _token;
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
      prefs.setBool('Profile', false);
      prefs.setString("FCMT", "");
      notifyListeners();
      return cred.user != null ? true : false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> checkUser() async {
    try {
      var user = true;
      CollectionReference users =
      FirebaseFirestore.instance.collection('Users');
      await users.doc(_auth.currentUser?.uid).get().then(
            (datasnapshot) => {
          if (!datasnapshot.exists) {user = false}
        },
      );
      if (!user) {
        _profileCreated = false;
      } else {
        _profileCreated = true;
      }
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
    _profileCreated = prefs.getBool('Profile')!;
    if (prefs.getString("FCMT") != null) {
      _fcmToken = prefs.getString("FCMT")!;
    }
    notifyListeners();
  }
}
