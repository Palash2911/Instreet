import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/postscreens/RegisterStall.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:instreet/views/widgets/homePageCard.dart';
import 'package:instreet/views/widgets/shimmerSkeleton.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostScreenNav extends StatefulWidget {
  const PostScreenNav({super.key});

  @override
  State<PostScreenNav> createState() => _PostScreenNavState();
}

class _PostScreenNavState extends State<PostScreenNav> {
  List<Stall> userStalls = [];
  var isLoading = false;
  var init = true;
  var currentUid = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      currentUid = Provider.of<Auth>(context, listen: false).token;
      loadAddedStalls(context);
    }
    init = false;
  }

  Future<void> loadAddedStalls(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<StallProvider>(context, listen: false).fetchStalls();
    } catch (e) {
      print(e);
    } finally {
      await Future.delayed(Duration(milliseconds: 700), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userStalls = currentUid.isNotEmpty
        ? Provider.of<StallProvider>(context)
            .getUserRegisteredStalls(currentUid)
        : [];
    return Scaffold(
      appBar: const AppBarWidget(
        isSearch: false,
        screenTitle: 'My Posts',
      ),
      body: isLoading
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
          : userStalls.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterStall(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add_circle,
                          size: 100,
                          color: kprimaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Creat Post",
                        style: kTextPopM16,
                      )
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => loadAddedStalls(context),
                  child: ListView.builder(
                    itemCount: userStalls.length,
                    itemBuilder: (context, index) {
                      final stall = userStalls[index];
                      return HomePageCard(stall: stall, isReview: false);
                    },
                  ),
                ),
      floatingActionButton: userStalls.isEmpty
          ? Container()
          : FloatingActionButton(
              backgroundColor: kprimaryColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RegisterStall(),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
    );
  }
}
