import 'package:flutter/material.dart';

class ProfileList extends StatefulWidget {
  final IconData icon;
  final String text;
  final Function()? ontap;
  ProfileList({super.key, required this.icon, required this.text, this.ontap});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: Colors.grey,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
