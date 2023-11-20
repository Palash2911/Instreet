import 'package:flutter/material.dart';

class PermissionList extends StatelessWidget {
  IconData icon;
  String tileText;
  String subTileText;
  
  PermissionList({
    super.key, 
    required this.icon,
    required this.tileText,
    required this.subTileText
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 9),
      child: ListTile(
        onTap: (){
          // permission logic
        },
        leading: Icon(
          icon as IconData?,
          color: Colors.orange,
          size: 30,
        ),
        title: Text(
          tileText,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          subTileText,
          maxLines: 2,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
