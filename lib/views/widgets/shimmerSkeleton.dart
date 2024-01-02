import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width - 20,
      margin: const EdgeInsets.all(10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(),
      ),
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  color: Colors.white,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 80,
                          height: 16,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 60,
                          height: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        buildShimmerListItem(),
        const SizedBox(height: 5),
        buildShimmerListItem(),
        const SizedBox(height: 5),
        buildShimmerListItem(),
        const SizedBox(height: 5),
        buildShimmerListItem(),
        const SizedBox(height: 5),
        buildShimmerListItem(),
      ],
    ),
  );
  }
}

Widget buildShimmerListItem() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            color: Colors.grey,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  color: Colors.grey,
                ),
                const SizedBox(height: 5),
                Container(
                  width: 100,
                  height: 10,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
