import 'package:flutter/material.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/widgets/homePageCard.dart';
import 'package:instreet/views/widgets/shimmerSkeleton.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../widgets/app_bar_search.dart';
import '../../widgets/carousal_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final stalls = Provider.of<StallProvider>(context).stalls;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: AppBarSearch(),
        backgroundColor: Colors.white,
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
                  child: Column(
                    children: [
                      const CarousalSlider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: stalls.length,
                          itemBuilder: (context, index) {
                            return HomePageCard(
                              stall: stalls[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: <Widget>[
      //       const CarousalSlider(),
      //
      //       ListTile(
      //         title: const Text(
      //           'Categories',
      //           style: TextStyle(
      //             fontSize: 16,
      //             fontWeight: FontWeight.w500
      //           ),
      //         ),
      //         trailing: IconButton(
      //           icon: Icon(isExpanded ? Icons.remove : Icons.add),
      //           onPressed: () {
      //             setState(() {
      //               isExpanded = !isExpanded;
      //             });
      //           },
      //         ),
      //       ),
      //
      //       AnimatedContainer(
      //         duration: const Duration(milliseconds: 500),
      //         height: isExpanded ? calculateGridHeight() : 100, // Adjust as needed
      //         child: const CategoriesItems(),
      //       ),
      //
      //       const ListTile(
      //         title: Text(
      //           'Trending',
      //           style: TextStyle(
      //             fontSize: 16,
      //             fontWeight: FontWeight.w500
      //           ),
      //         ),
      //       ),
      //
      //       // Trending widget bellow this
      //
      //     ],
      //   ),
    );
  }
}
