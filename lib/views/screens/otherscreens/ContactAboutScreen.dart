import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';

class ContactUs extends StatelessWidget {
  static var routeName = 'contact-us';
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {

    Widget contactUsList(String titleText, String subTitleText,IconData icon,Color iconColor) {
      return ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          titleText,
          style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subTitleText,
          style: const TextStyle(fontSize: 15),
        ),
      );
    }

    return Scaffold(
      appBar: const AppBarWidget(screenTitle: 'Contact Us', isSearch: false),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            contactUsList('Address', 'D Y Patil College Of Engineering Akurdi , Pune',Icons.location_on,Colors.blue),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            contactUsList('Phone', '+91 1743727491',Icons.phone,Colors.green),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            contactUsList('Email', 'instreetpvt@gmail.com',Icons.email,Colors.red)
          ],
        ),
      ),
    );
  }
}


class AboutUs extends StatefulWidget {
  static var routeName = 'about-us';
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  List<bool> showDetail = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(screenTitle: 'About Us', isSearch: false),
      body: ListView(
        children: [
          buildSection(0, "Mission", "Our mission is to enhance and transform the street food discovery experience through innovative use of Augmented Reality (AR) and advanced data analytics. We aim to provide street food enthusiasts with a user-friendly, dynamic platform that not only helps them discover new culinary delights but also enriches their dining adventures with personalized, context-aware recommendations."),
          buildSection(1, "Vision", "Our vision is to redefine the way people interact with street food environments, making the discovery process as enjoyable as the dining experience itself. By leveraging cutting-edge technologies like AR and machine learning, we strive to foster a vibrant community of food lovers who appreciate the rich tapestry of local and global street food cultures."),
          buildSection(2, "History", "Founded by a team of passionate food and technology enthusiasts, our project began with the goal of merging technological innovation with the burgeoning interest in street food. Since our inception, we have continuously evolved, incorporating user feedback and the latest technological advancements to improve and expand our services. Our journey from a simple idea to a robust platform reflects our commitment to excellence and community engagement in the culinary tech space."),
        ],
      ),
    );
  }

  Widget buildSection(int index, String title, String content) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black,
      margin: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black)),
            trailing: IconButton(
              icon: Icon(showDetail[index] ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  showDetail[index] = !showDetail[index];
                  for (int i = 0; i < showDetail.length; i++) {
                    if (i != index) showDetail[i] = false;
                  }
                });
              },
            ),
          ),
          if (showDetail[index])
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(content,style: const  TextStyle(fontSize: 18),),
            )
        ],
      ),
    );
  }
}
