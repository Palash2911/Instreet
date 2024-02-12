import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/views/screens/onboarding/Login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class PermissionBtn extends StatefulWidget {
  const PermissionBtn({super.key});

  @override
  State<PermissionBtn> createState() => _PermissionBtnState();
}

class _PermissionBtnState extends State<PermissionBtn> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: SwipeableButtonView(
        buttontextstyle: kTextPopB14.copyWith(color: Colors.white),
        buttonText: 'Start Exploring',
        buttonWidget: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey,
        ),
        activeColor: kprimaryColor,
        isFinished: isFinished,
        onWaitingProcess: () {
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              isFinished = true;
            });
          });
        },
        onFinish: () async {
          await Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const LoginScreen(),
            ),
          );
        },
      ),
    );
  }
}
