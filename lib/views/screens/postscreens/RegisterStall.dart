
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/views/screens/postscreens/StalImages.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class RegisterStall extends StatefulWidget {
  const RegisterStall({Key? key}) : super(key: key);

  @override
  State<RegisterStall> createState() => _RegisterStallState();
}

class _RegisterStallState extends State<RegisterStall> {
  
  final _form = GlobalKey<FormState>();

  String? selectedRole;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ownernameController = TextEditingController();

  final _otpController = TextEditingController();
  bool otpBtn = false;
  var isOtpEnable = false;
  var isLoading = false;
  String get name => _nameController.text;
  String get phone => _phoneController.text;
  String get ownername => _ownernameController.text;
  String phoneNo = "";
  String otp = "";
  bool isNextButtonEnabled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ownernameController.dispose();
    super.dispose();
  }

  Widget setTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future _sendOtP(BuildContext ctx) async {
    if (_form.currentState!.validate()) {
      isLoading = true;
      _form.currentState!.save();
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
        setState(() {
          otpBtn = true;
          isOtpEnable = true;
          isNextButtonEnabled = true;
        });
      });
    } else {
      Fluttertoast.showToast(
        msg: "Please fill in all the required fields!",
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
        if (user) {
          // Navigator.of(ctx).pushReplacementNamed('bottom-nav');
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const StallImages(),
          //   ),
          // );
        } else {
          Navigator.of(ctx).pushReplacementNamed('register-screen');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Invalid OTP!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xFFFF4500),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Invalid OTP!",
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
      appBar: const AppBarWidget(
        isSearch: false,
        screenTitle: 'My Posts',
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  setTitle("Describe Your Self"),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'owner',
                        groupValue: selectedRole,
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                        activeColor: kprimaryColor,
                      ),
                      const Text('Owner'),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                      Radio<String>(
                        value: 'creator',
                        groupValue: selectedRole,
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                        activeColor: kprimaryColor,
                      ),
                      const Text('Creator'),
                    ],
                  ),
                  setTitle("Stall Name"),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "Enter stall name",
                      hintStyle: kTextPopR14,
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter stall name!';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  setTitle("Owner's Name"),
                  TextFormField(
                    controller: _ownernameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "Enter owner's name",
                      hintStyle: kTextPopR14,
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter owner\'s name!';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  setTitle("Contact Number"),
                  IntlPhoneField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      hintStyle: kTextPopR14,
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
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
                  setTitle("Enter OTP"),
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
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_form.currentState!.validate() &&
                              phone.isNotEmpty) {
                            _sendOtP(context);
                            
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please fill the blank fields !",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: kprimaryColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Send OTP",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                              color: kprimaryColor,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      // this next button will only activate when otp is successfully verified   ---> as of now i have directly navigate to next screen i.e StallImages
                      GestureDetector(
                        onTap: () {
                          // if (isNextButtonEnabled) {
                          //   _verifyOtp(context);
                          // }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StallImages(role : selectedRole.toString() , name :name,ownername: ownername,contactnumber:phone),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Next",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: isNextButtonEnabled
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                          decoration: BoxDecoration(
                              color: isNextButtonEnabled
                                  ? kprimaryColor
                                  : Colors.grey.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
