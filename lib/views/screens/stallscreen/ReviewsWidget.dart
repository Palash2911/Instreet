import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/views/screens/stallscreen/ReviewCardWidget.dart';

import '../../../models/reviewModel.dart';

class ReviewsWidget extends StatefulWidget {
  final List<ReviewModel> stallReviews;
  final void Function() showDialogReview;
  final String creatorUid;
  final bool reviewDone;

  const ReviewsWidget({
    super.key,
    required this.stallReviews,
    required this.showDialogReview,
    required this.creatorUid,
    required this.reviewDone,
  });

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Reviews',
                style: kTextPopM16.copyWith(
                  fontSize: 17,
                  color: const Color(0xff39434F),
                ),
              ),
              !widget.reviewDone
                  ? InkWell(
                      onTap: widget.showDialogReview,
                      child: Row(
                        children: [
                          const Icon(Icons.add_circle_outline,
                              color: Colors.black54, size: 28),
                          const SizedBox(width: 9),
                          Text('Add Review',
                              style:
                                  kTextPopR14.copyWith(color: kprimaryColor)),
                        ],
                      ),
                    )
                  : const SizedBox(width: 0),
            ],
          ),
          const SizedBox(height: 15),
          widget.stallReviews.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'No Reviews Yet',
                      style: kTextPopB16,
                    ),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                    itemCount: widget.stallReviews.length,
                    itemBuilder: (context, index) {
                      final review = widget.stallReviews[index];
                      return StallReviewCard(
                        userName: review.userName,
                        rating: review.rating.roundToDouble(),
                        review: review.review,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
