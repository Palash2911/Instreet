import 'package:flutter/material.dart';

class LoginOpt extends StatefulWidget {
  String optionText;
  String imgUrl;
  LoginOpt({
    super.key,
    required this.imgUrl,
    required this.optionText
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
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Icon(
              Icons.login,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          child: Text('Sign In with Facebook'),
        ),
      ],
    );
  }
}
