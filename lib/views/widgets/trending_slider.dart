import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instreet/views/widgets/trending_items.dart';

class TrendingSlider extends StatelessWidget {
  final List<dynamic> trendingStalls;
  const TrendingSlider({super.key, required this.trendingStalls});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
      child: ListView(
        children: [
          CarouselSlider(
            items:
                trendingStalls.map((item) => TrendingItems(url: item.bannerImageUrl)).toList(),
            options: CarouselOptions(
              height: 200,
              aspectRatio: 20 / 8,
              viewportFraction: 1.0,
              initialPage: 0,
              autoPlay: trendingStalls.length == 1 ? false : true,
              enableInfiniteScroll: trendingStalls.length == 1 ? false : true,
              autoPlayInterval: const Duration(seconds: 3),
              enlargeCenterPage: true,
              enlargeFactor: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
