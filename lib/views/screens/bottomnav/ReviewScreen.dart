import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/reviewModel.dart';
import 'package:instreet/providers/reviewProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:instreet/views/widgets/homePageCard.dart';
import 'package:instreet/views/widgets/shimmer_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../providers/authProvider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  var isLoading = true;
  var init = true;
  var currentUid = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      currentUid = Provider.of<Auth>(context, listen: false).token;
      loadReviewData(context);
    }
    init = false;
  }

  Future<void> loadReviewData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<StallProvider>(context, listen: false).fetchStalls();
      await Provider.of<ReviewProvider>(context, listen: false).fetchReviews();
    } catch (e) {
      print(e);
    } finally {
      await Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stalls = currentUid.isNotEmpty
        ? Provider.of<StallProvider>(context, listen: false)
            .getNotUserStalls(currentUid)
        : [];
    final userReviews = currentUid.isNotEmpty
        ? Provider.of<ReviewProvider>(context, listen: false).allReviews
        : [];

    final filteredStalls = stalls
        .where((stall) => userReviews.any(
            (review) => (review.sid == stall.sId && review.uid == currentUid)))
        .toList();

    return Scaffold(
      appBar: const AppBarWidget(
        isSearch: false,
        screenTitle: 'Review',
      ),
      body: SafeArea(
        child: isLoading
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const ShimmerSkeleton(),
                  );
                },
              )
            : RefreshIndicator(
                onRefresh: () => loadReviewData(context),
                child: ListView.builder(
                  itemCount: filteredStalls.length,
                  itemBuilder: (context, index) {
                    var stall = filteredStalls[index];
                    var review = userReviews.firstWhere(
                      (r) => r.sid == stall.sId && r.uid == currentUid,
                      orElse: () => ReviewModel(
                        rid: '',
                        sid: '',
                        review: '',
                        rating: 0,
                        uid: '',
                        userName: '',
                      ),
                    );

                    return GestureDetector(
                      onLongPress: () async {
                        // Confirm deletion from the user
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
                                      Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: const Text("Delete"),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            );
                          },
                        );

                        if (delete) {
                          try {
                            await Provider.of<ReviewProvider>(context,listen: false).deleteReview(review.rid, currentUid);
                            Fluttertoast.showToast(
                              msg:"Review deleted Successfully!",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: kprimaryColor,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            loadReviewData(context);
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error deleting review: $error'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: review.sid.toString().isNotEmpty
                          ? HomePageCard(
                              stall: stall,
                              isReview: true,
                              review: review,
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
