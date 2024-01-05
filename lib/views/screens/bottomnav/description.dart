import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YourPage(),
    );
  }
}

class YourPage extends StatefulWidget {
  @override
  _YourPageState createState() => _YourPageState();
}

class _YourPageState extends State<YourPage> {
  int _selectedRole = 0; // 0 for Owner, 1 for Creator
  bool isFinished = false;
  int _otpTimer = 30; // Initial timer value in seconds
  late Timer _timer;
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_otpTimer > 0) {
          _otpTimer--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle back button tap
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'Describe yourself :',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 0,
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value as int;
                            });
                          },
                          activeColor: Color.fromARGB(255, 222, 83, 14),
                        ),
                        Text('Owner'),
                        SizedBox(width: 90),
                        Radio(
                          value: 1,
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value as int;
                            });
                          },
                          activeColor: Color.fromARGB(255, 222, 83, 14),
                        ),
                        Text('Creator'),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 16),
                    Text(
                      'Stall Name:',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 50,
                      child: TextFormField(
                        style: GoogleFonts.poppins(fontSize: 16),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Enter stall name',
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Owner's Name:",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 50,
                      child: TextFormField(
                        style: GoogleFonts.poppins(fontSize: 16),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter owner's name",
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Contact Number :',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 50,
                      child: TextFormField(
                        style: GoogleFonts.poppins(fontSize: 16),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Enter Contact Number',
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(height: 16),

                    // OTP Section
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter OTP:',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              6,
                              (index) => Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: otpControllers[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  onChanged: (value) {
                                    if (value.length == 1) {
                                      // Move to the next TextField
                                      if (index < otpControllers.length - 1) {
                                        FocusScope.of(context).nextFocus();
                                      } else {
                                        // Submit the OTP or perform any desired action
                                        // For now, print the OTP
                                        String otp = otpControllers
                                            .map(
                                                (controller) => controller.text)
                                            .join();
                                        print('Entered OTP: $otp');
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Text(
                              '00:${_otpTimer.toString().padLeft(2, '0')}',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: SwipeableButtonView(
                        buttontextstyle: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.white),
                        buttonText: 'Next',
                        buttonWidget: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                        ),
                        activeColor: Color.fromARGB(255, 222, 83, 14),
                        isFinished: isFinished,
                        onWaitingProcess: () {
                          Future.delayed(Duration(seconds: 2), () {
                            // Wait for 2 seconds at the middle
                            setState(() {
                              isFinished = true;
                            });
                          });
                        },
                        onFinish: () {
                          // Handle the button press
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
