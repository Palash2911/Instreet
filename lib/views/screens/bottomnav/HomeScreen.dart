import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/userProvider.dart';
import 'package:instreet/views/widgets/homePageCard.dart';
import 'package:instreet/views/widgets/shimmerSkeleton.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/constants.dart';
import '../../../models/userModel.dart';
import '../../widgets/app_bar_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference stallRef =
      FirebaseFirestore.instance.collection('stalls');
  var isLoading = true;
  var init = true;
  UserModel currentUser = UserModel(uid: '', favorites: []);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      loadUserData(context);
    }
    init = false;
  }

  Future loadUserData(BuildContext ctx) async {
    setState(() {
      isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(ctx, listen: false);
    await userProvider.getUser('GDLHs3YUAwYJe71jNzNG').then((value) {
      currentUser =
          UserModel(uid: 'GDLHs3YUAwYJe71jNzNG', favorites: value['favorites']);
    }).catchError((e) {
      print(e);
    });
    await Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
                  onRefresh: () => loadUserData(context),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: stallRef.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            height: 27,
                            child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: const ShimmerSkeleton(),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100.0,
                                  child: Image.asset(
                                    'assets/images/google.jpg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Text(
                                  "No Stalls Yet !",
                                  style: kTextPopM16,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var document = snapshot.data!.docs[index];
                              return HomePageCard(
                                stall: Stall(
                                  sId: document.id,
                                  stallName: document['stallName'],
                                  ownerName: document['ownerName'],
                                  rating: document['rating'].toDouble(),
                                  stallCategories: document['stallCategory'],
                                  stallDescription:
                                      document['stallDescription'],
                                  bannerImageUrl: document['bannerImage'],
                                ),
                                user: currentUser!,
                              );
                            },
                          );
                        }
                      }
                    },
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
