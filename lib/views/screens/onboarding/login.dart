import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/views/screens/onboarding/register.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';

import '../../../providers/authProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static var routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String otp = "";
  String phoneNo = "";
  int countdown = 45;
  var isLoading = false;
  final _form = GlobalKey<FormState>();

  bool otpBtn = false;
  var isOtpEnable = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = "";
    _otpController.text = "";
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // void startCountdown() {
  //   const oneSec = Duration(seconds: 1);
  //   Timer.periodic(oneSec, (Timer timer) {
  //     if (countdown == 0) {
  //       timer.cancel();
  //     } else {
  //       setState(() {
  //         countdown--;
  //       });
  //     }
  //   });
  // }

  // void resetCountdown() {
  //   setState(() {
  //     countdown = 45;
  //   });
  //   startCountdown();
  // }

  // String _formatDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //   return '$twoDigitMinutes:$twoDigitSeconds';
  // }

  Future _signInGoogle(BuildContext ctx) async {
    var authProvider = Provider.of<Auth>(ctx, listen: false);
    setState(() {
      isLoading = true;
    });
    await Provider.of<Auth>(ctx, listen: false).signInGoogle().catchError((e) {
      Fluttertoast.showToast(
        msg: e,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: kprimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }).then((value) async {
      if (value!=null) {
        Fluttertoast.showToast(
          msg: "Welcome To Instreet",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        var user = await authProvider.checkUser();
        // var fcmT = await FirebaseNotification().getToken();
        if (user) {
          // await Provider.of<UserProvider>(context, listen: false)
          //     .updateToken(fcmT.toString(), authProvider.token)
          //     .then((value) {
          //   const initin = 0;
          //
          // });
          if(mounted){
            Navigator.of(ctx).pushReplacementNamed('bottom-nav');
          }
        } else {
          if(mounted){
            Navigator.of(ctx).pushReplacementNamed('register-screen');
          }
        }
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  Future _sendOtP(BuildContext ctx) async {
    var isValid = _form.currentState!.validate();
    isLoading = true;
    _form.currentState!.save();
    if (isValid) {
      await Provider.of<Auth>(ctx, listen: false)
          .authenticate(phoneNo)
          .catchError((e) {
        Fluttertoast.showToast(
          msg: e,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }).then((_) {
        Fluttertoast.showToast(
          msg: "OTP Sent Successfully !",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // resetCountdown();
        setState(() {
          otpBtn = true;
          isOtpEnable = true;
        });
      });
    } else {
      Fluttertoast.showToast(
        msg: "Enter A Valid Number !",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future _verifyOtp(BuildContext ctx) async {
    isLoading = true;
    var isValid = false;
    var authProvider = Provider.of<Auth>(ctx, listen: false);
    otp = _otpController.text;
    if (otp.length == 6) {
      isValid = await authProvider.verifyOtp(otp).catchError((e) {
        return false;
      });
      if (isValid) {
        var user = await authProvider.checkUser();
        // var fcmT = await FirebaseNotification().getToken();
        if (user) {
          // await Provider.of<UserProvider>(context, listen: false)
          //     .updateToken(fcmT.toString(), authProvider.token)
          //     .then((value) {
          //   const initin = 0;
          //
          // });
          if(mounted){
            Navigator.of(ctx).pushReplacementNamed('bottom-nav');
          }
        } else {
          if(mounted){
            Navigator.of(ctx).pushReplacementNamed('register-screen');
          }
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Something Went Wrong !",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFFFF4500),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black.withOpacity(0.7),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox(width: 0),
              Container(
                height: MediaQuery.of(context).size.height * 0.81,
                padding: const EdgeInsets.only(left: 35, right: 35, top: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text(
                      'Welcome Explorer',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: 270,
                      child: SignInButton(
                        Buttons.google,
                        text: "Sign up with Google",
                        onPressed: () {
                          _signInGoogle(context);
                        },
                      ),
                    ),
                    // const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 2,
                          color: kprimaryColor,
                        ),
                        const Text("   OR   "),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 2,
                          color: kprimaryColor,
                        )
                      ],
                    ),
                    // const SizedBox(height: 20),
                    Form(
                      key: _form,
                      child: Column(
                        children: [
                          IntlPhoneField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              counterText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              suffixIcon: Container(
                                margin: const EdgeInsets.all(9.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isOtpEnable ? Colors.grey : kprimaryColor.withOpacity(0.9),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: isOtpEnable ? null : () {
                                    setState(() {
                                      // isFinished = true;
                                    });
                                    _sendOtP(context);
                                  },
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value!.number.isEmpty) {
                                return 'Please Enter Valid Number!';
                              }
                              return null;
                            },
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              setState(() {
                                phoneNo = phone.completeNumber.toString();
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            controller: _otpController,
                            enabled: isOtpEnable,
                            onChanged: (otp) {
                              setState(() {
                                otp = otp.toString();
                              });
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.grey.withOpacity(0.1),
                              // Adjust other styling properties as needed
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      opacity: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0),
                        child: ElevatedButton(
                          onPressed: otpBtn ? () => _verifyOtp(context) : null,
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(300, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: kprimaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: const TextStyle(
                                fontSize: 18,
                              )),
                          child: const Text('Start Exploring'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
