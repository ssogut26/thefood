import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class ProjectWidgets {
  ProjectWidgets._();
  static Widget buildRatingStar(double starValue) {
    final Color color = starValue < 2 ? Colors.red : Colors.green;
    final starIconsMap = [1, 2, 3, 4, 5].map((e) {
      if (starValue >= e) {
        return Icon(
          size: 15,
          Icons.star_rate,
          color: color,
        );
      } else if (starValue < e && starValue > e - 1) {
        return Icon(
          size: 15,
          Icons.star_half,
          color: color,
        );
      } else {
        return Icon(size: 15, Icons.star_border, color: color);
      }
    }).toList();

    return Row(children: starIconsMap);
  }

  static Future<Widget> getRatings(
      int index, List<double> ratings, BuildContext context, String mealId) async {
    ratings = <double>[];
    final ref = FirebaseFirestore.instance.collection('reviews').doc(mealId).get();
    await ref.then((value) {
      if (value.exists) {
        final data = value.data()?['review'] as List;
        for (var i = 0; i < data.length; i++) {
          ratings.add(data[i]['rating'] as double);
        }
      }
    });
    if (ratings.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProjectWidgets.buildRatingStar(0),
          Text('(${ratings.length})', style: context.textTheme.headline5),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProjectWidgets.buildRatingStar(ratings.average),
        Text('(${ratings.length})', style: context.textTheme.headline5),
      ],
    );
  }
}
