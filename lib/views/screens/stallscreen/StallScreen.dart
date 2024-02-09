import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/providers/reviewProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/stallscreen/menuImagesWidget.dart';
import 'package:instreet/views/screens/stallscreen/reviewsWidget.dart';
import 'package:instreet/views/screens/stallscreen/stallDescriptionWidget.dart';
import 'package:instreet/views/screens/stallscreen/stallImageCarouselWidget.dart';
import 'package:instreet/views/widgets/shimmerSkeleton.dart';
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
  var isInit = false;
  var isLoading = true;
  late Stall stall;
  List<ReviewModel> reviews = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      sId = ModalRoute.of(context)?.settings.arguments as String;
      getStallFromID();
    }
    setState(() {
      isInit = true;
    });
  }

  Future getStallFromID() async {
    setState(() {
      isLoading = true;
    });
    var stallProvider = Provider.of<StallProvider>(context, listen: false);
    var reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    var authToken = Provider.of<Auth>(context, listen: false).token;
    if (sId.isNotEmpty) {
      await stallProvider.fetchStalls();
      await reviewProvider.fetchReviews();
      if (mounted) {
        stall = stallProvider
            .getAllStalls(authToken)
            .firstWhere((stall) => stall.sId == sId);
        reviews = reviewProvider.getStallReview(sId);
      }
    } else {
      print('Some Error Occurred');
    }
    Future.delayed(const Duration(milliseconds: 1100), () {
      setState(() {
        isLoading = false;
      });
    });
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
                        stall.menuImages.length > 0
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
                          sId: sId,
                          creatorUid: stall.creatorUID,
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
