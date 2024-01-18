import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';

class ReviewCard extends StatelessWidget {
  final double rating;
  final String reviewText;
  final List<Widget> Function(double) buildStars;

  const ReviewCard({
    required this.rating,
    required this.reviewText,
    required this.buildStars,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Review',
                style: kTextPopM16.copyWith(color: kprimaryColor),
              ),
              Row(
                children: [
                  ...buildStars(rating), // Build stars based on the rating
                ],
              ),
            ],
          ),
          const SizedBox(height: 8), // Add space between Your Review text and stars
          Text(
            reviewText,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
