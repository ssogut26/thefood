import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/paddings.dart';

class RandomMealShimmer extends StatelessWidget {
  const RandomMealShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ProjectColors.lightGrey,
      highlightColor: ProjectColors.secondWhite,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.875,
            height: MediaQuery.of(context).size.height * 0.20,
            child: const Card(),
          ),
        ],
      ),
    );
  }
}

class CategoryMealShimmer extends StatelessWidget {
  const CategoryMealShimmer({
    super.key,
    required this.itemCount,
  });

  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1000),
      baseColor: ProjectColors.lightGrey,
      highlightColor: ProjectColors.secondWhite,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: context.dynamicWidth(0.5),
          mainAxisExtent: context.dynamicHeight(0.27),
        ),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, _) {
          return SizedBox(
            height: context.dynamicHeight(0.26),
            width: MediaQuery.of(context).size.width / 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: ProjectPaddings.cardImagePaddingSmall,
                child: SizedBox(
                  width: context.dynamicWidth(0.4),
                  height: context.dynamicHeight(0.22),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: context.lowBorderRadius,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ProjectColors.lightGrey,
      highlightColor: ProjectColors.secondWhite,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Column(
                  children: const [
                    SizedBox(
                      width: 84,
                      height: 50,
                      child: Card(),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: context.width * 0.4,
                height: context.height * 0.05,
                child: const Card(),
              ),
              SizedBox(
                width: context.width * 0.2,
                height: context.height * 0.05,
                child: const Card(),
              ),
            ],
          ),
          const CategoryMealShimmer(
            itemCount: 4,
          ),
        ],
      ),
    );
  }
}
