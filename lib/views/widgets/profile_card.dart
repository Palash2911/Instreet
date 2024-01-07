import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../providers/authProvider.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  var uName = '';
  var isCreator = false;
  var jDate = '';

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    var auth = Provider.of<Auth>(context, listen: false);
    try {
      setState(() {
        uName = auth.userName;
        isCreator = auth.isCreator;
        jDate = auth.joiningDate;
      });

    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    print(uName);
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
            const SizedBox(width: 6,),
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
