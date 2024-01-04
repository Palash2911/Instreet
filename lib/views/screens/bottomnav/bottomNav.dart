import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:instreet/views/screens/bottomnav/FavoriteScreen.dart';
import 'package:instreet/views/screens/bottomnav/HomeScreen.dart';
import 'package:instreet/views/screens/bottomnav/ProfileScreen.dart';
import 'package:instreet/views/screens/bottomnav/ReviewScreen.dart';
import 'package:instreet/views/screens/postscreens/Categories.dart';
import 'package:instreet/views/screens/postscreens/PostScreenNav.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../constants/constants.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});
  static var routeName = 'bottom-nav';

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final _controller = PersistentTabController(initialIndex: 0);
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = _buildScreens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        hideNavigationBarWhenKeyboardShows: true,
        resizeToAvoidBottomInset: true,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        navBarStyle: NavBarStyle.style6,
        confineInSafeArea: true,
      ),
    );
  }
}

List<Widget> _buildScreens() {
  return [
    HomeScreen(),
    FavroiteScreen(),
    PostScreenNav(),
    ReviewScreen(),
    ProfileScreen(),
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: ("Home"),
      activeColorPrimary: kprimaryColor,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(FeatherIcons.heart),
      title: ("Favourite"),
      activeColorPrimary: kprimaryColor,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.add_circle_outline),
      title: ("Post"),
      activeColorPrimary: kprimaryColor,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.reviews_outlined),
      title: ("Reviews"),
      activeColorPrimary: kprimaryColor,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.person_4_outlined),
      title: ("Profile"),
      activeColorPrimary: kprimaryColor,
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}
