import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instreet/models/stallModel.dart';
import 'package:instreet/views/widgets/homePageCard.dart';

import '../../../constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference stallRef =
      FirebaseFirestore.instance.collection('stalls');
  var isLoading = false;
  var init = true;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (init) {
  //     loadItems();
  //   }
  //   init = false;
  // }

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
                                stallDescription: document['stallDescription'],
                                bannerImageUrl: document['bannerImage'],
                              ),
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
