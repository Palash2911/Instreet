import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:instreet/views/widgets/profile_card.dart';
import 'package:instreet/views/widgets/profile_list.dart';
import 'package:instreet/views/widgets/shimmerSkeleton.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var isLoading = false;
  var init = true;
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
        print('hello');
        break;
      case "Edit Profile":
        if (mounted) {
          Navigator.of(context, rootNavigator: true)
              .pushNamed('edit-profile-screen');
        }
        break;
      case "Help":
        print("Hello3");
        break;
      default:
        {
          await Provider.of<Auth>(context, listen: false)
              .signOut()
              .then((value) {
            Fluttertoast.showToast(
              msg: 'Off the streets for now. Catch you soon on InStreet!!',
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              backgroundColor: kprimaryColor,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            if (mounted) {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed('/');
            }
          }).catchError((e) {
            print(e);
          });
        }
        break;
    }
  }

  Future onRefresh() async {
    isLoading = true;
    await Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
    });
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
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(24),
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: Column(
                    children: [
                      const ProfileCard(),
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
