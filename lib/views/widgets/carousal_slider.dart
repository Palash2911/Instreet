import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instreet/views/widgets/carousal_items.dart';

class CarousalSlider extends StatelessWidget {
  
  const CarousalSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      child: ListView(
        children: [
          CarouselSlider(
            items: [
              CarousalItems(url : "assets/images/carouser.jpg"),
              CarousalItems(url : "assets/images/carouser2.jpg"),
              CarousalItems(url : "assets/images/carouser4.jpg"),
              CarousalItems(url : "assets/images/carouser5.jpg"),
            ],
            options: CarouselOptions(
              height: 200,
              aspectRatio: 20 / 8,
              viewportFraction: 1.0,
              initialPage: 0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              enlargeCenterPage: true,
              enlargeFactor: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
