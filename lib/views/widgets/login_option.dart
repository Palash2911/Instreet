import 'package:flutter/material.dart';

class LoginOpt extends StatefulWidget {
  LoginOpt({
    super.key,
  });

  @override
  State<LoginOpt> createState() => _LoginOptState();
}

class _LoginOptState extends State<LoginOpt> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Image.asset('assets/images/google.png'),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text('Sign up with Google'),
      ],
    );
  }
}
