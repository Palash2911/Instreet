import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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
  void _launchDialer(String number) async {
    final url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch the dialer');
    }
  }

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
          InkWell(
            onTap: () => _launchDialer(widget.ownerContact),
            child: Row(
              children: [
                const Icon(
                  Icons.phone,
                  size: 26,
                ),
                const SizedBox(width: 9),
                Text(
                  widget.ownerContact,
                  style:
                      kTextPopM16.copyWith(color: Colors.black38, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
