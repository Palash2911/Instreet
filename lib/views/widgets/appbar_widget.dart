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
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.search, color: Colors.black),
                            onPressed: () {
                              // Handle search logic
                            },
                          ),
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search here",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                ],
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
