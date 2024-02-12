import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';

class ContactUs extends StatelessWidget {
  static var routeName = 'contact-us';
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(screenTitle: 'Contact Us', isSearch: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Contact us on: +911234567890',
                  style: kTextPopB16,
                ),
                const SizedBox(height: 25),
                Text(
                  'Email us on: instreet@gmail.com',
                  style: kTextPopB16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AboutUs extends StatelessWidget {
  static var routeName = 'about-us';
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(screenTitle: 'About Us', isSearch: false),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                const SizedBox(height: 45),
                Text('What is InStreet ?', style: kTextPopB16),
                const SizedBox(height: 10),
                Text(
                  'InStreet is a dynamic mobile application dedicated to empowering local street vendors by providing them with a platform to showcase their stalls. We bridge the gap between vibrant street markets and explorers eager to discover unique local treasures and authentic experiences.',
                  style: kTextPopR14,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 45),
                Text('What Do We Do ?', style: kTextPopB16),
                const SizedBox(height: 10),
                Text(
                  'InStreet enables street stalls to gain visibility by listing on our app, where users can explore, review, and favorite them. We offer a unique space for users to contribute by adding deserving stalls, browsing categories, and engaging with the local street market community.',
                  style: kTextPopR14,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
