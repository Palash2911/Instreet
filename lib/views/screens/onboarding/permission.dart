import 'package:flutter/material.dart';
import 'package:instreet/views/screens/onboarding/login.dart';
import 'package:instreet/views/widgets/permission_list.dart';
import 'package:instreet/views/widgets/permission_slide_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Payment App',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Text(
                      "For a more exciting experience",
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Text(
                      "The following access are required",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Text(
                      "Raaequired access",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ListView(
                      children: [
                        PermissionList(
                          icon: Icons.folder_outlined,
                          tileText: "Storage access",
                          subTileText:
                              "Need to be able to store data , such as ypur profile information",
                        ),
                        PermissionList(
                          icon: Icons.wifi,
                          tileText: "Device IP",
                          subTileText: "Need to identifying your devices",
                        ),
                        PermissionList(
                          icon: Icons.camera_outlined,
                          tileText: "Camera",
                          subTileText:
                              "Need to take photos or videos of your favorite K-pop idols",
                        ),
                        PermissionList(
                          icon: Icons.mic_outlined,
                          tileText: "Microphone",
                          subTileText:
                              "Need to reecord voic messages or to participate in live chats",
                        ),
                        PermissionList(
                          icon: Icons.location_on_outlined,
                          tileText: "Location",
                          subTileText:
                              "Need to access your location to provude K-pop events or concerts",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PermissionBtn()
          ],
        ),
      ),
    );
  }
}
