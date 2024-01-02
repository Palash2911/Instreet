import 'package:flutter/material.dart';

class AboutUsList extends StatelessWidget {
  final IconData? icon ;
  final String text;
  const AboutUsList({super.key,this.icon,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(
        children: [
          (icon==null) ?Container() : Icon(
            icon,
            color: Colors.grey,
          ),
          (icon==null) ?Container() : const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
