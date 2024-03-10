import 'package:flutter/material.dart';

class TrendingItems extends StatelessWidget {
  String url;
  TrendingItems({super.key,required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}
