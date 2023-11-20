import 'package:flutter/material.dart';
import 'package:instreet/views/widgets/permission_list.dart';
import 'package:instreet/views/widgets/permission_slide_button.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Payment App',
    home: PermissionScreen(),
  ));
}

class PermissionScreen extends StatefulWidget {
  static var routeName = 'permission-screen';
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.87,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 9),
                    child: const Text(
                      "InStreet Thrills Await You",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                    child: const Text(
                      "Required access",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.30,
                    child: ListView(
                      children: [
                        PermissionList(
                          icon: Icons.folder_outlined,
                          tileText: "Storage access",
                          subTileText:
                              "To store your favorite stores",
                        ),
                        PermissionList(
                          icon: Icons.camera_outlined,
                          tileText: "Camera",
                          subTileText:
                              "To explore our AR feature",
                        ),
                        PermissionList(
                          icon: Icons.location_on_outlined,
                          tileText: "Location",
                          subTileText:
                              "To recommend the best In your Street",
                        ),
                      ],
                    ),
                  ),
                  const PermissionBtn()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
