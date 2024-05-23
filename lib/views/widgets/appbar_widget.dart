import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final bool isSearch;
  final String screenTitle;
  final Function(String)? onSearch;
  final PersistentTabController? controller;

  const AppBarWidget({
    super.key,
    required this.isSearch,
    required this.screenTitle,
    this.onSearch,
    this.controller,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(
        kToolbarHeight,
      );
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
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Icon(Icons.search, color: Colors.black),
                        const SizedBox(width: 10),
                        Flexible(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Search Stall Name",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            style: const TextStyle(color: Colors.black),
                            onChanged: widget.onSearch,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    widget.controller?.jumpToTab(4);
                  },
                  child: const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/profile_avtar.png'),
                  ),
                ),
              ],
            ),
      backgroundColor: ksecondaryColor.withOpacity(0.8),
      iconTheme: const IconThemeData(color: Colors.white, size: 30),
      elevation: 3,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }
}
