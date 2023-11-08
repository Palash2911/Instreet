import 'package:flutter/material.dart';
import 'package:instreet/views/screens/onboarding/login.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
      child: SwipeableButtonView(
        buttonText: 'Start Exploring',
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
                type: PageTransitionType.fade, child: DashboardScreen()
            ),
          );
          setState(() {
            isFinished = false;
          });
        },
      ),
    );
  }
}
