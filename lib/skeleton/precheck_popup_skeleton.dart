import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PrecheckPopupSkeleton extends StatelessWidget {
  const PrecheckPopupSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondaryFixed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(context, width: 120, height: 14),
                    const SizedBox(height: 5),
                    shimmerBox(context, width: 80, height: 12),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(context, width: 100, height: 14),
                const SizedBox(height: 5),
                shimmerBox(context, width: 200, height: 12),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 1.5,
            children: List.generate(6, (index) => _buildSkeletonCard(context)),
          ),
          const SizedBox(height: 10),
          shimmerBox(context, width: 150, height: 30, borderRadius: 24),
        ],
      ),
    );
  }
}

Widget shimmerBox(
  BuildContext context, {
  double width = double.infinity,
  double height = 12,
  double borderRadius = 8,
}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}

Widget _buildSkeletonCard(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onSecondaryFixed,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        shimmerBox(context, width: 60, height: 14),
        const SizedBox(height: 5),
        shimmerBox(context, width: 100, height: 12),
      ],
    ),
  );
}
