import 'package:flutter/material.dart';
import 'package:instreet/views/screens/postscreens/Categories.dart';
import 'package:instreet/views/widgets/app_bar_search.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:instreet/views/widgets/carousal_slider.dart';
import 'package:instreet/views/widgets/categories_items.dart';
import '../../../constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: AppBarSearch(),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const CarousalSlider(),
            
            ListTile(
              title: const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
              trailing: IconButton(
                icon: Icon(isExpanded ? Icons.remove : Icons.add),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: isExpanded ? calculateGridHeight() : 100, // Adjust as needed
              child: const CategoriesItems(),
            ),

            const ListTile(
              title: Text(
                'Trending',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),

            // Trending widget bellow this 

          ],
        ),
      ),
    );
  }
}
