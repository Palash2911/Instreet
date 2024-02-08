import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/authProvider.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/postscreens/RegisterStall.dart';
import 'package:instreet/views/widgets/appbar_widget.dart';
import 'package:instreet/views/widgets/myPostCard.dart';
import 'package:instreet/views/widgets/shimmerSkeleton.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PostScreenNav extends StatefulWidget {
  const PostScreenNav({super.key});

  @override
  State<PostScreenNav> createState() => _PostScreenNavState();
}

class _PostScreenNavState extends State<PostScreenNav> {
  List<Stall> getStalls = [];
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
      print('this is current user id : ' + currentUid);
      getStalls = Provider.of<StallProvider>(context, listen: false)
          .getUserRegisteredStalls(currentUid);
      print(getStalls.length);
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
          : getStalls.isEmpty
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
                      SizedBox(height: 16),
                      Text(
                        "Creat Post",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => loadAddedStalls(context),
                  child: ListView.builder(
                    itemCount: getStalls.length,
                    itemBuilder: (context, index) {
                      final stall = getStalls[index];
                      print("printed stalliDS ${stall.sId}");
                      return MyPostCard(stall: stall, isReview: false,sId: stall.sId);
                    },
                  ),
                ),
      floatingActionButton: getStalls.length == 0
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
