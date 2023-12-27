import 'package:flutter/material.dart';
import 'package:instreet/constants/constants.dart';
import 'package:instreet/views/screens/postscreens/Categories.dart';

class CategoriesItems extends StatefulWidget {
  const CategoriesItems({super.key});

  @override
  State<CategoriesItems> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesItems> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Categories.routeName);
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(categories[index].imagePath),
                radius: 35,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              categories[index].name,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
            ),
          ],
        );
      },
    );
  }
}
