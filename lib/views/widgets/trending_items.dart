import 'package:flutter/material.dart';

class TrendingItems extends StatelessWidget {
  String url;
  TrendingItems({super.key,required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
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
