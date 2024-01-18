import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/constants.dart';
import '../../../models/stallModel.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/stallProvider.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/carousal_slider.dart';
import '../../widgets/homePageCard.dart';
import '../../widgets/shimmerSkeleton.dart';

class FavroiteScreen extends StatefulWidget {
  const FavroiteScreen({Key? key}) : super(key: key);

  @override
  State<FavroiteScreen> createState() => _FavroiteScreenState();
}

class _FavroiteScreenState extends State<FavroiteScreen> {
  var isLoading = true;
  var init = true;
  var currentUid = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      currentUid = Provider.of<Auth>(context, listen: false).token;
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
      await Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteStalls = currentUid.isNotEmpty
        ? Provider.of<StallProvider>(context).getFavoriteStalls(currentUid)
        : [];
    return Scaffold(
      appBar: AppBarWidget(isSearch: false, screenTitle: 'Favorites'),
      body: SafeArea(
        child: isLoading
            ? ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const ShimmerSkeleton(),
                  );
                },
              )
            : Container(
                height: MediaQuery.of(context).size.height -
                    kBottomNavigationBarHeight,
                padding: const EdgeInsets.only(bottom: 20),
                child: RefreshIndicator(
                  onRefresh: () => loadStallsData(context),
                  child: ListView.builder(
                    itemCount: favoriteStalls.length,
                    itemBuilder: (context, index) {
                      return HomePageCard(
                        stall: favoriteStalls[index],
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
