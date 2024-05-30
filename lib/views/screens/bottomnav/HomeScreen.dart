import 'dart:async';
import 'package:flutter/material.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/otherscreens/Categories.dart';
import 'package:instreet/views/widgets/header_widget.dart';
import 'package:instreet/views/widgets/homePageCard.dart';
import 'package:instreet/views/widgets/shimmer_skeleton.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/constants.dart';
import '../../../providers/authProvider.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/trending_slider.dart';
import '../../widgets/categories_items.dart';

class HomeScreen extends StatefulWidget {
  final PersistentTabController controller;
  const HomeScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = true;
  var init = true;
  bool isHeaderExpanded = false;
  var currentUid = '';
  var isSearching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      currentUid = Provider.of<Auth>(context, listen: false).token;
      loadStallsData(context);
    }
    init = false;
  }

  void _handleHeaderExpansion(bool expanded) {
    setState(() {
      isHeaderExpanded = expanded;
    });
  }

  void loadSearchStalls(String query) {
    if (query.isEmpty) {
      isSearching = false;
      Provider.of<StallProvider>(context, listen: false).fetchStalls();
    } else {
      isSearching = true;
      Provider.of<StallProvider>(context, listen: false)
          .getSearchStalls(query, currentUid);
    }
    setState(() {});
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

  void navigateCategory(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Categories(
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stalls = currentUid.isNotEmpty
        ? Provider.of<StallProvider>(context).getNotUserStalls(currentUid)
        : [];

    final trendingStalls = currentUid.isNotEmpty
        ? Provider.of<StallProvider>(context).getTrendingStalls(currentUid)
        : [];

    stalls.sort((a, b) => b.rating.compareTo(a.rating));

    return Scaffold(
      appBar: AppBarWidget(
        isSearch: true,
        screenTitle: 'Home',
        onSearch: (query) {
          loadSearchStalls(query);
        },
        controller: widget.controller,
      ),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        !isSearching && trendingStalls.length > 0
                            ? TrendingSlider(
                                trendingStalls: trendingStalls,
                              )
                            : SizedBox(width: 0),
                        !isSearching
                            ? HeaderWidget(
                                expandedView: true,
                                title: 'Categories',
                                isExpanded: isHeaderExpanded,
                                onExpansionChanged: _handleHeaderExpansion,
                              )
                            : const SizedBox(width: 0),
                        !isSearching
                            ? AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: isHeaderExpanded
                                    ? calculateGridHeight()
                                    : (true)
                                        ? 100
                                        : 0,
                                // Adjust as needed
                                child: CategoriesItems(
                                  NavigateCategory: navigateCategory,
                                ),
                              )
                            : const SizedBox(width: 0),
                        const HeaderWidget(
                          expandedView: false,
                          title: 'All Stalls',
                          isExpanded: false,
                        ),
                        ...stalls
                            .map((stall) => HomePageCard(
                                  stall: stall,
                                  isReview: false,
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
