import 'package:flutter/material.dart';
import 'package:instreet/providers/stallProvider.dart';
import 'package:instreet/views/screens/stallscreen/reviewsWidget.dart';
import 'package:instreet/views/screens/stallscreen/stallDescriptionWidget.dart';
import 'package:instreet/views/screens/stallscreen/stallImageCarouselWidget.dart';
import 'package:provider/provider.dart';

import '../../../models/stallModel.dart';

class StallScreen extends StatefulWidget {
  const StallScreen({super.key});
  static var routeName = 'stall-screen';

  @override
  State<StallScreen> createState() => _StallScreenState();
}

class _StallScreenState extends State<StallScreen> {
  var sId = '';
  var isInit = false;
  var isLoading = true;
  late Stall stall;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      sId = ModalRoute.of(context)?.settings.arguments as String;
      getStallFromID();
    }
    setState(() {
      isInit = true;
    });
  }

  Future getStallFromID() async {
    setState(() {
      isLoading = true;
    });
    var stallProvider = Provider.of<StallProvider>(context, listen: false);
    if (sId.isNotEmpty) {
      await stallProvider.fetchStalls();
      if (mounted) {
        stall = stallProvider.stalls.firstWhere((stall) => stall.sId == sId);
      }
    } else {
      print('Some Error Occurred');
    }
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isLoading ? Text(stall.stallName) : const Text(''),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: getStallFromID,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 18),
                    child: Column(
                      children: [
                        StallImageCarouselWidget(
                          stallImages: stall.stallImages,
                        ),
                        StallDescWidget(
                          stallDesc: stall.stallDescription,
                          stallLocation: stall.location,
                          ownerName: stall.ownerName,
                          ownerContact: stall.ownerContact,
                        ),
                        ReviewsWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
