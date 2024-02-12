import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';

class StallReviewCard extends StatelessWidget {
  final String userName;
  final double rating;
  final String review;

  const StallReviewCard({
    super.key,
    required this.userName,
    required this.rating,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
          side: const BorderSide(color: Colors.grey, width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      userName,
                      style: kTextPopM16.copyWith(fontSize: 15),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        color: index < rating ? Colors.amber : Colors.grey,
                        size: 20,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                review,
                style: kTextPopR14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
