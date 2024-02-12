import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class ProfileCard extends StatelessWidget {
  final String uName;
  final bool isCreator;
  final String jDate;

  const ProfileCard(
      {super.key,
      required this.uName,
      required this.isCreator,
      required this.jDate});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.grey, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Image.asset(
              "assets/images/profile_avtar.png",
            ),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      uName,
                      style: kTextPopB16,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: kprimaryColor,
                      ),
                      child: Text(
                        isCreator ? 'Creator' : 'Explorer',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Since : $jDate",
                      style: kTextPopR12,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
