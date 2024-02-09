import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/views/screens/bottomnav/Categories.dart';

class CategoriesItems extends StatefulWidget {
  const CategoriesItems({super.key, required this.NavigateCategory});
  final Function(String) NavigateCategory;

  @override
  State<CategoriesItems> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesItems> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => widget.NavigateCategory(categories[index].name),
                child: CircleAvatar(
                  backgroundImage: AssetImage(categories[index].imagePath),
                  radius: 30,
                ),
              ),
              Expanded(
                child: AutoSizeText(
                  categories[index].name,
                  style: kTextPopR14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
