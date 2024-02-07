import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instreet/models/reviewModel.dart';
import 'package:instreet/providers/reviewProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:instreet/views/widgets/homePageCard.dart';
import 'package:instreet/views/widgets/shimmerSkeleton.dart';
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
      await Provider.of<ReviewProvider>(context, listen: false)
          .fetchReviews(currentUid);
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
    final stalls = Provider.of<StallProvider>(context).stalls;
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
                        (r) => r.sid == stall.sId,
                        orElse: () => ReviewModel(
                            rid: '', sid: '', review: '', rating: 0, uid: ''));
                    if (review.sid.toString().isNotEmpty) {
                      return HomePageCard(
                        stall: stall,
                        isReview: true,
                        review: review,
                      );
                    }
                    return null;
                  },
                ),
              ),
      ),
    );
  }
}
