import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/providers/reviewProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/stallscreen/MenuImagesWidget.dart';
import 'package:instreet/views/screens/stallscreen/ReviewsWidget.dart';
import 'package:instreet/views/screens/stallscreen/StallDescriptionWidget.dart';
import 'package:instreet/views/screens/stallscreen/StallImageCarouselWidget.dart';
import 'package:instreet/views/widgets/shimmer_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/reviewModel.dart';
import '../../../models/stallModel.dart';
import '../../../providers/authProvider.dart';

class StallScreen extends StatefulWidget {
  const StallScreen({super.key});
  static var routeName = 'stall-screen';

  @override
  State<StallScreen> createState() => _StallScreenState();
}

class _StallScreenState extends State<StallScreen> {
  var sId = '';
  var isCreator = '';
  var isInit = false;
  var isLoading = true;
  late Stall stall;
  List<ReviewModel> reviews = [];
  var reviewDone = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      final args = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
      sId = args[0] as String;
      isCreator = args[1] as String;
      getStallFromID();
    }
    setState(() {
      isInit = true;
    });
  }

  Future<void> getStallFromID() async {
    setState(() {
      isLoading = true;
    });
    var stallProvider = Provider.of<StallProvider>(context, listen: false);
    var reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    var authToken = Provider.of<Auth>(context, listen: false).token;
    if (sId.isNotEmpty) {
      await stallProvider.fetchStalls();
      await reviewProvider.fetchReviews();
      if (isCreator == 'user') {
        reviews = reviewProvider.getStallReview(sId);
        stall = stallProvider
            .getNotUserStalls(authToken)
            .firstWhere((stall) => stall.sId == sId);
        var userReview = reviews
            .where((review) => (review.uid == authToken && review.sid == sId));
        if (userReview.isEmpty || reviews.isEmpty) {
          setState(() {
            reviewDone = false;
          });
        } else if (userReview.isNotEmpty) {
          setState(() {
            reviewDone = true;
          });
        }
      } else {
        stall = stallProvider
            .getUserRegisteredStalls(authToken)
            .firstWhere((stall) => stall.sId == sId);
        setState(() {
          reviewDone = true;
        });
      }
    }
    Future.delayed(const Duration(milliseconds: 1100), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _showAddReviewDialog() {
    final TextEditingController _reviewController = TextEditingController();
    int _currentRating = 0;

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
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.sentences,
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
                            if (_reviewController.text.isNotEmpty &&
                                _currentRating != 0) {
                              var authProvider =
                                  Provider.of<Auth>(context, listen: false);
                              await Provider.of<ReviewProvider>(context,
                                      listen: false)
                                  .addReview(
                                ReviewModel(
                                  rid: 'rid',
                                  sid: sId,
                                  review: _reviewController.text,
                                  rating: _currentRating.toDouble(),
                                  uid: authProvider.token,
                                  userName: authProvider.userName,
                                ),
                              );
                              if (mounted) {
                                  await Provider.of<StallProvider>(context, listen: false)
                                      .updateStallReview(
                                    _currentRating.toDouble(),
                                    sId,
                                    reviews.length + 1,
                                  );
                                getStallFromID();
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
    return Scaffold(
      appBar: AppBar(
        title: !isLoading ? Text(stall.stallName) : const Text(''),
      ),
      body: isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: const StallShimmerSkeleton(),
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: getStallFromID,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 18),
                    child: Column(
                      children: [
                        StallImageCarouselWidget(
                          stallImages: stall.stallImages,
                        ),
                        StallDescWidget(
                          stallDesc: stall.stallDescription,
                          stallLocation: stall.location,
                          ownerName: stall.ownerName,
                          ownerContact: stall.ownerContact,
                        ),
                        stall.menuImages.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      'Menu / Services',
                                      style: kTextPopM16.copyWith(
                                          fontSize: 17,
                                          color: const Color(0xff39434F)),
                                    ),
                                    const SizedBox(height: 15),
                                    StallMenuImages(
                                        menuImages: stall.menuImages),
                                  ],
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 30, bottom: 10),
                                child: Text(
                                  'No Services / Menu !',
                                  style: kTextPopB16,
                                ),
                              ),
                        ReviewsWidget(
                          stallReviews: reviews,
                          showDialogReview: _showAddReviewDialog,
                          creatorUid: stall.creatorUID,
                          reviewDone: reviewDone,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
