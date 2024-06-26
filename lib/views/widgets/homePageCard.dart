import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/reviewModel.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/reviewProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/widgets/review_card.dart';
import 'package:provider/provider.dart';

class HomePageCard extends StatefulWidget {
  final Stall stall;
  final bool isReview;
  final ReviewModel? review;
  final currentUid;
  final loadReviewData;
  HomePageCard(
      {super.key,
      required this.stall,
      required this.isReview,
      this.review,
      this.currentUid,
      this.loadReviewData});

  @override
  State<HomePageCard> createState() => _HomePageCardState();
}

class _HomePageCardState extends State<HomePageCard> {
  bool isFavorite = false;
  var uid = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      uid = Provider.of<Auth>(context, listen: false).token;
      isFavorite = widget.stall.favoriteUsers.contains(uid);
    });
  }

  void _navigateStallScreen(String sId) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      'stall-screen',
      arguments: [sId, 'user'],
    );
  }

  Future toggleFav() async {
    setState(() {
      isFavorite = !isFavorite;
    });
    var sProvider = Provider.of<StallProvider>(context, listen: false);
    try {
      await sProvider.toggleFavorite(widget.stall.sId, uid);
    } catch (e) {
      print(e);
    }
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
                      ? SizedBox(
                          width: 9,
                        )
                      : SizedBox(
                          width: 0,
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
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
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
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
                          if (widget.isReview != null &&
                              widget.isReview == true)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.52,
                                  child: Text(
                                    widget.stall.stallDescription,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    bool delete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Delete Review"),
                                          content: const Text(
                                              "Are you sure you want to delete this review?"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text("Cancel"),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                            ),
                                            TextButton(
                                              child: const Text("Delete"),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (delete) {
                                      try {
                                        await Provider.of<ReviewProvider>(
                                                context,
                                                listen: false)
                                            .deleteSingleReview(
                                                widget.review!.rid,
                                                widget.currentUid);
                                        Fluttertoast.showToast(
                                          msg: "Review deleted Successfully!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: kprimaryColor,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                        widget.loadReviewData(context);
                                      } catch (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Error deleting review: $error'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ],
                            )
                          else
                            Container(),
                          if (widget.isReview != null &&
                              widget.isReview == true)
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
                    IconButton(
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons
                                .favorite_border, // Toggle between filled and outline
                        color: kprimaryColor,
                        size: 27, // Your predefined color
                      ),
                      onPressed: toggleFav,
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
