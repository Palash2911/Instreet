import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/views/screens/otherscreens/SplashScreen.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:instreet/views/widgets/profile_card.dart';
import 'package:instreet/views/widgets/profile_list.dart';
import 'package:instreet/views/widgets/shimmer_skeleton.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final controller;
  const ProfileScreen({super.key, required this.controller});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  var isLoading = false;
  var init = true;
  String uName = '';
  String jDate = '';
  bool isCreator = false;
  bool otpSent = false;
  bool isLinkMobileExpanded = false;

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
          Navigator.of(context, rootNavigator: true).pushNamed('about-us');
        }
        break;
      case "Contact Us":
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pushNamed('contact-us');
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

  Future<void> _sendOtp(BuildContext context) async {
    if (_phoneController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a phone number.");
      return;
    }

    setState(() {
      isLoading = true;
      otpSent = false;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .sendOtp("+91" + _phoneController.text.trim());
      setState(() {
        otpSent = true;
      });
      Fluttertoast.showToast(msg: "OTP sent to ${_phoneController.text}");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to send OTP: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _linkPhoneNumber(BuildContext context) async {
    setState(() => isLoading = true);
    try {
      await Provider.of<Auth>(context, listen: false)
          .linkPhoneNumber(_otpController.text);
      Fluttertoast.showToast(msg: "Phone number linked successfully!");
      _otpController.clear();
      setState(() {
        otpSent = false;
        _otpController.clear();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to link phone number: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _linkAccountButton(Auth authProvider) {
    print("this is auth with google ${authProvider.isUserAuthenticatedWithGoogle()}");
    if (authProvider.isAuth && !authProvider.isUserAuthenticatedWithGoogle()) {
      // If the user is authenticated but not with Google, show link Google button
      return ElevatedButton(
        onPressed: () => authProvider.linkGoogleAccount(),
        child: const  Text('Link Google Account'),
      );
      // return ProfileList(
      //   icon: Icons.mail,
      //   ontap: () => authProvider.linkGoogleAccount(),
      //   text: "Link Google Account",
      // );

    } else if (authProvider.isAuth && authProvider.isUserAuthenticatedWithGoogle()) {
      const SizedBox(height: 18);
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 26),
        // padding: const EdgeInsets.all(15.0),
        // width: 310,
        // height:54,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.2),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text('Link Mobile Number'),
              onTap: () {
                setState(() {
                  isLinkMobileExpanded = !isLinkMobileExpanded;
                });
              },
            ),
            if (isLinkMobileExpanded)
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    IntlPhoneField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        setState(() {
                          otpSent = false;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) {
                        _otpController.text = value;
                      },
                      beforeTextPaste: (text) => true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          otpSent ? _linkPhoneNumber(context) : _sendOtp(context),
                      child: Text(otpSent ? 'Link Phone Number' : 'Send OTP'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<Auth>(context);
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
                      const SizedBox(height: 18),
                      _linkAccountButton(authProvider),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
