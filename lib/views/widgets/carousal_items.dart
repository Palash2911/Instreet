import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CarousalItems extends StatelessWidget {
  String url;
  CarousalItems({super.key,required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(url),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}
