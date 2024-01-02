import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/views/widgets/about_usList.dart';
import 'package:instreet/views/widgets/profile_list.dart';
import 'package:instreet/views/widgets/shimmerSkeleton.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

Future<Map<String, String?>> fetchUserDetails(String uid) async {
  try {
    DocumentSnapshot userDocument = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDocument.exists) {
      Timestamp createdAtTimestamp = userDocument.get('CreatedAt');
      DateTime createdAtDateTime = createdAtTimestamp.toDate();
      String formattedDate = DateFormat('dd MMM yyyy').format(createdAtDateTime); // Format the date
      return {
        'Name': userDocument.get('Name'),
        'Since': formattedDate,
      };
    } else {
      return {};
    }
  } catch (e) {
    print("Error fetching user data: $e");
    return {};
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Auth>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: null,
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: fetchUserDetails(profile.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ProfileSkeleton(); // Shimmer effect while loading
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            String? name = snapshot.data?['Name'];
            String? since = snapshot.data?['Since'];
            return buildProfile(name, since,profile,context); // Build profile with fetched data
          }
        },
      ),
    );
  }
}


Widget buildProfile(String? name, String? since,final profile,BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/profile_avtar.png",
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: kprimaryColor,
                            ),
                            child: const  Text(
                              "Creator",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "#food, #salon, #style ",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Since : ${since}",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ProfileList(icon: Icons.list,text: "My Stalls",),
            const SizedBox(
              height: 10,
            ),
            ProfileList(icon: Icons.edit,text: "Edit Profile",),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AboutUsList(icon: Icons.help, text: "Help"),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  AboutUsList(icon: Icons.phone, text: "Contact Us"),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  AboutUsList(icon: Icons.info, text: "About Us"),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  AboutUsList(text: "Terms & Conditions")
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ProfileList(icon: Icons.logout,text: "Log Out",ontap : ()=> _showSignOutConfirmation(context, profile.signOut)),
          ],
        ),
      );
  }


  void _showSignOutConfirmation(BuildContext context, Function signOut) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Sign Out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Sign Out'),
          onPressed: () {
            signOut();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
      ],
    ),
  );
}


