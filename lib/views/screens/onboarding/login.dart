import 'package:flutter/material.dart';
import 'package:instreet/views/widgets/login_option.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool obscureText = true;
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/background_image.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginOpt(
                      imgUrl: "facebook.png",
                      optionText: "FaceBook",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    LoginOpt(
                      imgUrl: "google.png",
                      optionText: "Google",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 2,
                      color: Colors.orange,
                    ),
                    Text("   OR   "),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 2,
                      color: Colors.orange,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email, color: Colors.white),
                      hintText: 'Enter your email',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      hintText: 'Enter your password',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20),
                child: SwipeableButtonView(
                  buttonText: 'Sign In',
                  buttonWidget: Container(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                    ),
                  ),
                  activeColor: Colors.orange,
                  isFinished: isFinished,
                  onWaitingProcess: () {
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        isFinished = true;
                      });
                    });
                  },
                  onFinish: () async {
                    await Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: DashboardScreen()),
                    );
                    setState(() {
                      isFinished = false;
                    });
                  },
                ),
              ),
              Text(
                "Don't have and account ? (sign Up)",
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 3,
                margin: EdgeInsets.only(
                  left: 150,
                  right: 150
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
