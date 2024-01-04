import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import 'categories_items.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({
    super.key,
    required this.expandedView,
    required this.title,
    required this.isExpanded,
    this.onExpansionChanged,
  });

  final bool expandedView;
  final String title;
  final bool isExpanded;
  final Function(bool)? onExpansionChanged;

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {

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
              icon: Icon(widget.isExpanded ? Icons.remove : Icons.add),
              onPressed: () {
                widget.onExpansionChanged!(!widget.isExpanded); // Update this
              },
            )
                : null,
          ),
        ],
      ),
    );
  }
}
