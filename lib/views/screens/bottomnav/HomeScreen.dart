import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/providers/userProvider.dart';
import 'package:instreet/views/widgets/homePageCard.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../models/userModel.dart';

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

  Future<void> loadUserData(BuildContext ctx) async {
    final userProvider = Provider.of<UserProvider>(ctx);
    await userProvider.getUser('GDLHs3YUAwYJe71jNzNG').then((value) {
      setState(() {
        isLoading = false;
        currentUser = UserModel(uid: 'GDLHs3YUAwYJe71jNzNG',favorites: value['favorites']);
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    });
  }

  Future loadItems() async {
    isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 25.0,
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height -
                    kBottomNavigationBarHeight,
                padding: const EdgeInsets.only(bottom: 20),
                child: RefreshIndicator(
                  onRefresh: loadItems,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: stallRef.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: SizedBox(
                            height: 27,
                            child: CircularProgressIndicator(),
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
    );
  }
}
