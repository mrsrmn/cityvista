import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/utils.dart';
import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/pages/main/place_details/place_details.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class PlaceCard extends StatelessWidget {
  final CityPlace place;
  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Get.to(() => PlaceDetails(place: place));
      },
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
                  Utils.buildPlaceStars(place),
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