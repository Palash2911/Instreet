import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        verificationCompleted: (PhoneAuthCredential credential) async {},
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
      notifyListeners();
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
                  prefs.setString("JDate",DateFormat("dd MMM, yyyy").format(dataSnapshot['CreatedAt'].toDate())),
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
      await prefs.clear();
      await _auth.signOut();
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

  Future<void> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString("UserName")!;
    _isCreator = prefs.getBool("IsCreator")!;
    _joiningDate = prefs.getString("JDate")!;
  }

  Future<void> sendOtp(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.currentUser!.linkWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }

  // account link functions
  bool isUserAuthenticatedWithGoogle() {
    return _auth.currentUser?.providerData
            .any((provider) => provider.providerId == 'google.com') ??
        false;
  }

  // Checks if the user's phone number is linked
  bool isPhoneNumberLinked() {
    User? user = _auth.currentUser;
    if (user != null) {
      for (var info in user.providerData) {
        if (info.providerId == 'phone') {
          return true;
        }
      }
    }
    return false;
  }

  // link phone number 
  Future<void> linkPhoneNumber(String smsCode) async {
    var phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      await _auth.currentUser!.linkWithCredential(phoneAuthCredential);
      print("Phone number linked successfully!");
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print(e);
    }
  }

  // link google account
  Future<void> linkGoogleAccount() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        await _auth.currentUser!.linkWithCredential(credential);
        Fluttertoast.showToast(
          msg: 'Google account linked successfully!',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print("Google account linked successfully!");

        notifyListeners();
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print(e);
      }
    }
  }
}
