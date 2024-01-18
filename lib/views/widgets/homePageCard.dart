import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/widgets/review_card.dart';
import 'package:provider/provider.dart';

class HomePageCard extends StatefulWidget {
  final Stall stall;
  final bool? isReview;
  const HomePageCard({super.key, required this.stall, this.isReview});

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

  // function to create rating star 
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
    return Column(
      children: [
        Container(
          height: 120,
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
                  child: Image.network(
                    widget.stall.bannerImageUrl,
                    fit: BoxFit.cover,
                    height: 150,
                    width: 120,
                  ),
                ),
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

        // this review will be shown only if it is review screen 
        if (widget.isReview != null && widget.isReview == true)
          ReviewCard(
            rating: widget.stall.rating,
            reviewText: "This is sample text here we are going to pass the actuall review which user has added",
            buildStars: buildStars, // Passing the buildStars function
          ),
      ],
    );
  }
}
