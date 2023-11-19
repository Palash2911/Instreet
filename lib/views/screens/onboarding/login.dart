import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/views/screens/onboarding/register.dart';
import 'package:instreet/views/widgets/login_option.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../../providers/authProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static var routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String get otp => _otpController.text;
  String phoneNo = "";

  var isLoading = false;
  final _form = GlobalKey<FormState>();

  // late bool isFinished;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   isFinished = true;
    // });
    _phoneController.text = "";
    _otpController.text = "";
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future _sendOtP(BuildContext ctx) async {
    final isValid = _form.currentState!.validate();
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
          backgroundColor: const Color(0xFFFF4500),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }).then((value) {
        Fluttertoast.showToast(
          msg: "OTP Sent Successfully !",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xFFFF4500),
          textColor: Colors.white,
          fontSize: 16.0,
        );
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
            print('old user');
          } else {
            Navigator.of(ctx).pushReplacementNamed(RegisterScreen.routeName);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 35.0, vertical: 145.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Welcome Explorer',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginOpt(),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 2,
                      color: Colors.orange,
                    ),
                    const Text("   OR   "),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 2,
                      color: Colors.orange,
                    )
                  ],
                ),
                const SizedBox(height: 20),
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
                            margin: EdgeInsets.all(9.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFF4500).withOpacity(0.9),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
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
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border:Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: _otpController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                const Icon(Icons.lock, color: Color(0xff555C69)),
                            hintText: 'Enter OTP',
                            hintStyle: TextStyle(
                                color: Color(0xff555C69).withOpacity(0.7)),
                          ),
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
                        horizontal: 20.0, vertical: 20),
                    child: SwipeableButtonView(
                            buttonText: 'Start Exploring',
                            buttonWidget: const Icon(
                              Icons.arrow_forward,
                              color: Colors.grey,
                            ),
                            activeColor: Color(0xFFFF4500),
                            isFinished: false,
                            onWaitingProcess: () {
                              _verifyOtp(context);
                              // Future.delayed(Duration(seconds: 2), () {
                              //   setState(() {
                              //     // isFinished = true;
                              //   });
                              // });
                            },
                            onFinish: () async {
                              print('hello');
                            },
                          )
                         // If not finished, show an empty SizedBox
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
