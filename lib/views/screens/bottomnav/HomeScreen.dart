import 'package:flutter/material.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/postscreens/Categories.dart';
import 'package:instreet/views/widgets/header_widget.dart';
import 'package:instreet/views/widgets/homePageCard.dart';
import 'package:instreet/views/widgets/shimmerSkeleton.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/constants.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/carousal_slider.dart';
import '../../widgets/categories_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = true;
  var init = true;
  bool isHeaderExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      loadStallsData(context);
    }
    init = false;
  }

  void _handleHeaderExpansion(bool expanded) {
    setState(() {
      isHeaderExpanded = expanded;
    });
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

  void navigateCategory(int index) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => const Categories(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final stalls = Provider.of<StallProvider>(context).stalls;
    
    return Scaffold(
      appBar: AppBarWidget(isSearch: true, screenTitle: 'Home'),
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
                        const CarousalSlider(),
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
                          title: 'Trending',
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
