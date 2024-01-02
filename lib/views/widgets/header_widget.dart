import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'categories_items.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget(
      {super.key, required this.expandedView, required this.title});
  final bool expandedView;
  final String title;

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              widget.title,
              style: kTextPopR16,
            ),
            trailing: widget.expandedView
                ? IconButton(
                    icon: Icon(isExpanded ? Icons.remove : Icons.add),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  )
                : null,
          ),
          // Put this in the HomeScreen and handle the container expansion there
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: isExpanded ? calculateGridHeight() : (widget.expandedView) ? 100 : 0,
            // Adjust as needed
            child: const CategoriesItems(),
          ),
        ],
      ),
    );
  }
}
