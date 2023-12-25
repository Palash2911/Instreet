import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/stallModel.dart';

class HomePageCard extends StatefulWidget {
  final Stall stall;
  const HomePageCard({super.key, required this.stall});

  @override
  State<HomePageCard> createState() => _HomePageCardState();
}

class _HomePageCardState extends State<HomePageCard> {
  bool isHeartFilled = false;

  List<Widget> buildStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    double partialStar = rating - fullStars;
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber));
    }
    if (partialStar > 0) {
      stars.add(Stack(
        children: [
          const Icon(Icons.star_border, color: Colors.amber),
          ClipRect(
            child: Align(
              alignment: Alignment.topLeft,
              widthFactor: partialStar,
              child: const Icon(Icons.star, color: Colors.amber),
            ),
          ),
        ],
      ));
    }
    for (int i = fullStars + (partialStar > 0 ? 1 : 0); i < 5; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber));
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width - 20,
      margin: const EdgeInsets.all(10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(15)),
              child: Image.network(
                widget.stall.bannerImageUrl,
                fit: BoxFit.cover,
                height: 150,
                width: 120,
              ),
            ), // 6358854363 - Mahindra
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 9.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      widget.stall.stallName,
                      style: kTextPopR16,
                      maxLines: 2,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.stall.stallCategories
                            .map(
                              (category) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  '#$category',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    // Text(widget.stall.stallDescription),
                    Row(
                      children: [
                        ...buildStars(widget.stall.rating),
                        const SizedBox(width: 6),
                        Text(widget.stall.rating.toStringAsFixed(1),
                            style: kTextPopR14),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isHeartFilled
                    ? Icons.favorite
                    : Icons
                    .favorite_border, // Toggle between filled and outline
                color: kprimaryColor,
                size: 27,// Your predefined color
              ),
              onPressed: () {
                setState(() {
                  isHeartFilled =
                  !isHeartFilled; // Toggle the state
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
