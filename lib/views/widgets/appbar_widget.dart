import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final bool isSearch;
  final String screenTitle;
  const AppBarWidget(
      {super.key, required this.isSearch, required this.screenTitle});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(
      kToolbarHeight); // Increased height for bottom curve
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: !widget.isSearch
            ? Text(
                widget.screenTitle,
                style: kTextPopB24.copyWith(color: Colors.white),
              )
            : Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
        backgroundColor: ksecondaryColor.withOpacity(0.8),
        elevation: 3,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ));
  }
}
