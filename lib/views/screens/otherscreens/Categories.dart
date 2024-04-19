import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:provider/provider.dart';

import '../../../providers/authProvider.dart';
import '../../../providers/stallProvider.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/header_widget.dart';
import '../../widgets/homePageCard.dart';

class Categories extends StatefulWidget {
  final String category;
  const Categories({super.key, required this.category});
  static var routeName = "categories-screen";

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var isLoading = true;
  var init = true;

  var currentUid = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      currentUid = Provider.of<Auth>(context, listen: false).token;
      loadCategoryStalls(context);
    }
    init = false;
  }

  Future<void> loadCategoryStalls(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    final categoryStalls = currentUid.isNotEmpty
        ? Provider.of<StallProvider>(context)
            .getCategoryStalls(widget.category, currentUid)
        : [];

    return Scaffold(
        appBar: AppBarWidget(isSearch: false, screenTitle: '${widget.category} Stalls'),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => loadCategoryStalls(context),
            child: SingleChildScrollView(
              child: categoryStalls.isEmpty ? Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/emptyCategoryScreen.png',
                      ),
                    ],
                  ),
                ),
              ) : Column(
                children: [
                  ...categoryStalls
                      .map(
                        (stall) => HomePageCard(
                          stall: stall,
                          isReview: false,
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          ),
        ));
  }
}
