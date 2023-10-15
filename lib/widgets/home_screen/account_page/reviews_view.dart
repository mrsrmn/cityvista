import 'package:flutter/material.dart';

import 'package:cityvista/other/models/city_review.dart';

import '../place_details/review_card.dart';

class ReviewsView extends StatelessWidget {
  final List<CityReview> reviews;

  const ReviewsView({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Center(child: Text("You don't have any reviews!"));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: reviews.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ReviewCard(review: reviews[index]),
          );
        },
      );
    }
  }
}