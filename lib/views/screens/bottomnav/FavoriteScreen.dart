import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/constants.dart';
import '../../../models/stallModel.dart';
import '../../../models/userModel.dart';
import '../../../providers/userProvider.dart';
import '../../widgets/homePageCard.dart';
import '../../widgets/shimmerSkeleton.dart';

class FavroiteScreen extends StatefulWidget {
  const FavroiteScreen({super.key});

  @override
  State<FavroiteScreen> createState() => _FavroiteScreenState();
}

class _FavroiteScreenState extends State<FavroiteScreen> {
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

  Future<void> loadUserData(BuildContext ctx) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
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
                                  "No Favorites Yet !",
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
                              if (currentUser.favorites.contains(document.id)) {
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
                                  user: currentUser,
                                );
                              } else {
                                return SizedBox
                                    .shrink(); // Skip the item if it's not a favorite
                              }
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
