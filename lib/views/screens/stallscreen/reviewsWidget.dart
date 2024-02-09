import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/reviewProvider.dart';
import 'package:instreet/views/screens/stallscreen/reviewCardWidget.dart';
import 'package:provider/provider.dart';

import '../../../models/reviewModel.dart';

class ReviewsWidget extends StatefulWidget {
  final List<ReviewModel> stallReviews;
  final String sId;
  final String creatorUid;
  const ReviewsWidget({
    super.key,
    required this.stallReviews,
    required this.sId,
    required this.creatorUid,
  });

  @override
  State<ReviewsWidget> createState() => _ReviewsWidgetState();
}

class _ReviewsWidgetState extends State<ReviewsWidget> {
  void _showAddReviewDialog(BuildContext context) {
    final TextEditingController _reviewController = TextEditingController();
    int _currentRating = 0;
    var authToken = Provider.of<Auth>(context, listen: false).token;
    if (widget.creatorUid == authToken) {
      Fluttertoast.showToast(
        msg: "Creators Can't Review !",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFFFF4500),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget _buildStar(int index) {
              return IconButton(
                icon: Icon(
                  _currentRating >= index + 1 ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _currentRating = index + 1;
                  });
                },
              );
            }

            return Dialog(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              backgroundColor: Colors.white,
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 25, right: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Review',
                      style: kTextPopM16,
                    ),
                    const SizedBox(height: 9),
                    TextField(
                      controller: _reviewController,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Review Here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 1.0),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Rating',
                      style: kTextPopM16,
                    ),
                    const SizedBox(height: 9),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) => _buildStar(index)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel',
                              style: kTextPopM16.copyWith(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (_reviewController.text.isNotEmpty) {
                              var authProvider =
                                  Provider.of<Auth>(context, listen: false);
                              await Provider.of<ReviewProvider>(context,
                                      listen: false)
                                  .addReview(
                                ReviewModel(
                                  rid: 'rid',
                                  sid: widget.sId,
                                  review: _reviewController.text,
                                  rating: _currentRating.toDouble(),
                                  uid: authProvider.token,
                                  userName: authProvider.userName,
                                ),
                              );
                              if (mounted) {
                                Navigator.of(context).pop();
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "Enter Review and Rating !!",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: const Color(0xFFFF4500),
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                          child: Text('Add Review', style: kTextPopM16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
              Text('Reviews',
                  style: kTextPopM16.copyWith(
                      fontSize: 17, color: const Color(0xff39434F))),
              InkWell(
                onTap: () => _showAddReviewDialog(context),
                child: Row(
                  children: [
                    const Icon(Icons.add_circle_outline,
                        color: Colors.black54, size: 28),
                    const SizedBox(width: 9),
                    Text('Add Review',
                        style: kTextPopR14.copyWith(color: kprimaryColor)),
                  ],
                ),
              )
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
