import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/views/screens/otherscreens/SplashScreen.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:instreet/views/widgets/profile_card.dart';
import 'package:instreet/views/widgets/profile_list.dart';
import 'package:instreet/views/widgets/shimmer_skeleton.dart';
import 'package:provider/provider.dart';

import 'BottomNav.dart';

class ProfileScreen extends StatefulWidget {
  final controller;
  const ProfileScreen({super.key, required this.controller});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var isLoading = false;
  var init = true;
  String uName = '';
  String jDate = '';
  bool isCreator = false;

  @override
  void didChangeDependencies() {
    if (init) {
      onRefresh();
    }
    init = false;
    super.didChangeDependencies();
  }

  void onProfileListTap(ListName) async {
    switch (ListName) {
      case "My Stalls":
        widget.controller.jumpToTab(2);
        break;
      case "Edit Profile":
        if (mounted) {
          Navigator.of(context, rootNavigator: true)
              .pushNamed('edit-profile-screen');
        }
        break;
      case "About Us":
        if (mounted) {
          Navigator.of(context, rootNavigator: true)
              .pushNamed('about-us');
        }
        break;
      case "Contact Us":
        if (mounted) {
          Navigator.of(context, rootNavigator: true)
              .pushNamed('contact-us');
        }
        break;
      default:
        {
          await Provider.of<Auth>(context, listen: false)
              .signOut()
              .catchError((e) {
            print(e);
          });
          if (mounted) {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SplashScreen()),
              (Route<dynamic> route) => false,
            );
          }
          Fluttertoast.showToast(
            msg: 'Off the streets for now. Catch you soon on InStreet!!',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: kprimaryColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        break;
    }
  }

  Future onRefresh() async {
    setState(() {
      isLoading = true;
    });
    var auth = Provider.of<Auth>(context, listen: false);
    try {
      await auth.getProfile();
      uName = auth.userName;
      isCreator = auth.isCreator;
      jDate = auth.joiningDate;
      await Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        isSearch: false,
        screenTitle: 'Profile',
      ),
      body: isLoading
          ? const ProfileSkeleton()
          : RefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    ProfileCard(
                      uName: uName,
                      isCreator: isCreator,
                      jDate: jDate,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ProfileList(
                      icon: Icons.list,
                      text: "My Stalls",
                      ontap: onProfileListTap,
                    ),
                    const SizedBox(height: 18),
                    ProfileList(
                      icon: Icons.edit,
                      text: "Edit Profile",
                      ontap: onProfileListTap,
                    ),
                    const SizedBox(height: 18),
                    ProfileList(
                      icon: Icons.help,
                      text: "Help",
                      ontap: onProfileListTap,
                    ),
                    const SizedBox(height: 18),
                    ProfileList(
                      icon: Icons.logout_rounded,
                      text: "Sign Out",
                      ontap: onProfileListTap,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
