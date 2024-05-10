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
      Provider.of<StallProvider>(context, listen: false).fetchStalls();
    } else {
      Provider.of<StallProvider>(context, listen: false)
          .getSearchStalls(query, currentUid);
    }
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
                        trendingStalls.length > 0
                            ? TrendingSlider(trendingStalls: trendingStalls,)
                            : SizedBox(width: 0),
                        HeaderWidget(
                          expandedView: true,
                          title: 'Categories',
                          isExpanded: isHeaderExpanded,
                          onExpansionChanged: _handleHeaderExpansion,
                        ),
                        AnimatedContainer(
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
                        ),
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
