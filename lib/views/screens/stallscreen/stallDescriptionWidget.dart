import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';

class StallDescWidget extends StatefulWidget {
  final String stallDesc;
  final String stallLocation;
  final String ownerName;
  final String ownerContact;
  const StallDescWidget({
    super.key,
    required this.stallDesc,
    required this.stallLocation,
    required this.ownerName,
    required this.ownerContact,
  });

  @override
  State<StallDescWidget> createState() => _StallDescWidgetState();
}

class _StallDescWidgetState extends State<StallDescWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.stallDesc,
            softWrap: true,
            style: kTextPopM16.copyWith(
                color: const Color(0xff39434F), fontSize: 14),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Location: ${widget.stallLocation}",
            softWrap: true,
            style: kTextPopM16.copyWith(color: Colors.black38, fontSize: 14),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            "Owner Name: ${widget.ownerName}",
            softWrap: true,
            style: kTextPopM16.copyWith(color: Colors.black38, fontSize: 14),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.ownerContact,
                style: kTextPopM16.copyWith(color: Colors.black38, fontSize: 14),
              ),
              const Icon(Icons.phone),
            ],
          ),
        ],
      ),
    );
  }
}
