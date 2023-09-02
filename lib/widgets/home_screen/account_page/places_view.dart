import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/other/models/city_review.dart';

class PlacesView extends StatelessWidget {
  final List<CityPlace> places;

  const PlacesView({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Center(child: Text("You don't have any places!"));
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (BuildContext context, int index) {
        CityPlace place = places[index];

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                children: [
                  if (place.images.isNotEmpty)
                    buildImage(place),

                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        buildRating(place),
                        Text(
                          place.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget buildRating(CityPlace place) {
    Widget stars = const Text("Loading Rating");
    num rating = 1;
    int reviewCount = 1;

    if (place.reviews.isEmpty) {
      rating = place.authorRating;
    } else {
      reviewCount = place.reviews.length + 1;

      for (CityReview review in place.reviews) {
        rating = rating + review.rating;
      }
    }

    if (1 <= rating && rating < 2) {
      stars = const Row(
        children: [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
        ],
      );
    } else if (2 <= rating && rating < 3) {
      stars = const Row(
        children: [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
        ],
      );
    } else if (3 <= rating && rating < 4) {
      stars = const Row(
        children: [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
        ],
      );
    } else if (4 <= rating && rating < 5) {
      stars = const Row(
        children: [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.grey),
        ],
      );
    } else {
      stars = const Row(
        children: [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
        ],
      );
    }

    return Row(
      children: [
        stars,
        const SizedBox(width: 5),
        Text("($reviewCount)", style: const TextStyle(fontSize: 18))
      ],
    );
  }

  Widget buildImage(CityPlace place) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      width: double.infinity,
      height: 150,
      imageUrl: place.images[0]
    );
  }
}