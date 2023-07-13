import 'package:flutter/material.dart';
import 'package:maps/widgets/shimmer.dart';

class DestinationSkeleton extends StatelessWidget {
  const DestinationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: MyShimmer(
        height: 30,
        width: double.infinity,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyShimmer(width: double.infinity, height: 40),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      actions: [
        MyShimmer(width: 80, height: 20),
        MyShimmer(width: 100, height: 20),
      ],
    );
  }
}
