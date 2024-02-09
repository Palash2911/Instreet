import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/reviewModel.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/onboarding/register.dart';
import 'package:instreet/views/screens/postscreens/RegisterStall.dart';
import 'package:instreet/views/widgets/review_card.dart';
import 'package:provider/provider.dart';

class MyPostCard extends StatefulWidget {
  final Stall stall;
  final bool isReview;
  final ReviewModel? review;
  final String sId;
  final Function(String) onDelete;

  MyPostCard({
    super.key,
    required this.stall,
    required this.isReview,
    this.review,
    required this.sId,
    required this.onDelete,
  });

  @override
  State<MyPostCard> createState() => _MyPostCardState();
}

class _MyPostCardState extends State<MyPostCard> {
  var uid = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      uid = Provider.of<Auth>(context, listen: false).token;
    });
  }

  void _navigateStallScreen(String sId) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      'stall-screen',
      arguments: sId,
    );
  }

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
    return InkWell(
      onTap: () => _navigateStallScreen(widget.stall.sId),
      child: Column(
        children: [
          Container(
            height: widget.isReview ? 100 : 120,
            width: MediaQuery.of(context).size.width - 20,
            margin: const EdgeInsets.all(10),
            child: Card(
              elevation: widget.isReview != null && widget.isReview == true
                  ? 0
                  : 4, // Conditional elevation
              shape: widget.isReview != null && widget.isReview == true
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide.none, // No border when condition is true
                    )
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius:
                        (widget.isReview != null && widget.isReview == true)
                            ? const BorderRadius.horizontal(
                                left: Radius.circular(15),
                                right: Radius.circular(15))
                            : const BorderRadius.horizontal(
                                left: Radius.circular(15)),
                    child: widget.isReview
                        ? Image.network(
                            widget.stall.bannerImageUrl,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 90,
                          )
                        : Image.network(
                            widget.stall.bannerImageUrl,
                            fit: BoxFit.cover,
                            height: 150,
                            width: 120,
                          ),
                  ),
                  widget.isReview
                      ? const SizedBox(
                          width: 9,
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 9.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !widget.isReview
                              ? AutoSizeText(
                                  widget.stall.stallName,
                                  style: kTextPopR16,
                                  maxLines: 2,
                                )
                              : const SizedBox(
                                  width: 0,
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
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          if (widget.isReview != null && widget.isReview == true)
                            Text(
                              widget.stall.stallDescription,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          else
                            Container(),
                          if (widget.isReview != null && widget.isReview == true)
                            Container()
                          else
                            Row(
                              children: [
                                ...buildStars(widget.stall.rating),
                                const SizedBox(width: 6),
                                Text(
                                  widget.stall.rating.toStringAsFixed(1),
                                  style: kTextPopR14,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.isReview != null && widget.isReview == true)
                    Container()
                  else
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: kprimaryColor,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterStall(sId: widget.sId),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Align(
                                        alignment: Alignment.center,
                                        child: Text("Farewell !!",
                                            style: kTextPopB24)),
                                    content: const Text(
                                        "Is It Goodbye Time For This Stall?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          widget.onDelete(widget.sId);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.isReview != null && widget.isReview == true)
            ReviewCard(
              rating: widget.review!.rating,
              reviewText: widget.review!.review,
              buildStars: buildStars,
              stallName: widget.stall.stallName,
            ),
        ],
      ),
    );
  }
}
