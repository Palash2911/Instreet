import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../providers/authProvider.dart';
import '../../../providers/stallProvider.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/homePageCard.dart';
import '../../widgets/shimmer_skeleton.dart';

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
      await Future.delayed(const Duration(milliseconds: 500), () {
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
      appBar: const AppBarWidget(isSearch: false, screenTitle: 'Favorites'),
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
            : favoriteStalls.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/noFavourite.png',
                          height: 300,
                        ),
                        // const Text(
                        //   'No favourite yet!',
                        //   style: TextStyle(
                        //       fontSize: 24, fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
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
                            isReview: false,
                          );
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}
