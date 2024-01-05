import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';

class ProfileList extends StatefulWidget {
  final IconData icon;
  final String text;
  final Function(dynamic) ontap;
  ProfileList(
      {super.key, required this.icon, required this.text, required this.ontap});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  bool isExpanded = false;
  List<IconData> iconsHelp = [
    Icons.info_outline,
    Icons.phone,
    Icons.event_note,
  ];

  List<String> textHelp = [
    'About Us',
    'Contact Us',
    'Terms & Conditions',
  ];

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.text == "Help"
          ? _toggleExpanded
          : widget.icon != Icons.logout_rounded
              ? () => widget.ontap(widget.text)
              : () => _showSignOutConfirmation(context, widget.ontap),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(15.0),
        width: 310,
        height: isExpanded && widget.text == "Help" ? 216 : 54,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.2),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    widget.text,
                    style: kTextPopR14.copyWith(
                        color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              if (isExpanded && widget.text == "Help")
                ...List.generate(
                  3,
                  (index) => Column(
                    children: [
                      const SizedBox(height: 6),
                      const Divider(
                        thickness: 2,
                        color: Colors.black38,
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => widget.ontap(textHelp[index]),
                        child: Row(
                          children: [
                            const SizedBox(width: 9),
                            Icon(iconsHelp[index], color: Colors.black54),
                            const SizedBox(width: 9),
                            Text(textHelp[index], style: kTextPopR12,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showSignOutConfirmation(BuildContext context, Function signOut) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Confirm Sign Out',
        style: kTextPopM16,
      ),
      content: Text(
        'Leaving InStreet So Soon ?',
        style: kTextPopR14,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'CANCEL',
            style: kTextPopB14,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('SIGN OUT', style: kTextPopB14),
          onPressed: () => signOut('Sign Out'),
        ),
      ],
    ),
  );
}
