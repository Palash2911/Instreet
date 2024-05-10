import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/views/screens/stallscreen/ARWidget.dart';

class StallImageCarouselWidget extends StatefulWidget {
  final List<dynamic> stallImages;
  const StallImageCarouselWidget({super.key, required this.stallImages});

  @override
  State<StallImageCarouselWidget> createState() =>
      _StallImageCarouselWidgetState();
}

class _StallImageCarouselWidgetState extends State<StallImageCarouselWidget> {
  int _currentIndex = 0;

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: InteractiveViewer(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(11),
                  margin: const EdgeInsets.all(11),
                  width: 220,
                  color: kprimaryColor,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.of(context, rootNavigator: true).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => ARObjectsScreen(imagePath: 'assets/images/book.jpg', isLocal: true),
                      //   ),
                      // );
                    },
                    child: Text(
                      'View in AR',
                      style: kTextPopB16.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: widget.stallImages.length > 1 ? true : false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 1800),
                height: 300,
                viewportFraction: 1.0,
                enableInfiniteScroll:
                    widget.stallImages.length > 1 ? true : false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: widget.stallImages.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () => _showImageDialog(image),
                      child: Padding(
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
