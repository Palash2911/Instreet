import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/views/screens/onboarding/permission.dart';
import 'package:provider/provider.dart';

import '../../../providers/authProvider.dart';

class SplashScreen extends StatefulWidget {
  static var routeName = 'splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadScreen(context);
  }

  Future loadScreen(BuildContext ctx) async {
    var authProvider = Provider.of<Auth>(context, listen: false);
    await Future.delayed(const Duration(seconds: 3), () async {
      await authProvider.autoLogin().then((_) async {
        if (authProvider.isAuth) {
          var user = await authProvider.checkUser();
          if(user && mounted) {
            Navigator.of(ctx).pushReplacementNamed('bottom-nav');
          } else {
            if(mounted) {
              Navigator.of(ctx).pushReplacementNamed('login');
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: kprimaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              width: 350,
              child: Image.asset('assets/images/logo.gif'),
            ),
          ],
        ),
      ),
    );
  }
}
