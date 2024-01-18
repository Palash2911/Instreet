import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/widgets/homePageCard.dart';
import 'package:instreet/views/widgets/shimmerSkeleton.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}



class _ReviewScreenState extends State<ReviewScreen> {
  var isLoading = true;
  var init = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      loadStallsData(context);
    }
    init = false;
  }

  Future<void> loadStallsData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<StallProvider>(context, listen: false).fetchStalls();
    } catch (e) {
      print(e);
    } finally {
      await Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stalls = Provider.of<StallProvider>(context).stalls;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: null,
        ),
        title: const Text(
          "Review",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? ListView.builder(
                physics:BouncingScrollPhysics(),
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
              onRefresh:() => loadStallsData(context),
               child: ListView.builder(
                itemCount: stalls.length,
                itemBuilder: (context, index) {
                  return HomePageCard(stall: stalls[index],isReview: true);
                },
              ),
            )
      ),
    );
  }
}
