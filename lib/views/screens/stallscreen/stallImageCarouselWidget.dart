import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';

class StallImageCarouselWidget extends StatefulWidget {
  final List<dynamic> stallImages;
  const StallImageCarouselWidget({super.key, required this.stallImages});

  @override
  State<StallImageCarouselWidget> createState() =>
      _StallImageCarouselWidgetState();
}

class _StallImageCarouselWidgetState extends State<StallImageCarouselWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 1800),
                height: 300,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: widget.stallImages.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          image.toString(),
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
        Positioned(
          top: 24,
          right: 28,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.8),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              '${_currentIndex + 1}/${widget.stallImages.length}',
              style: kTextPopM16.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
