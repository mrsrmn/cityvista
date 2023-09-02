import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/other/utils.dart';
import 'package:cityvista/widgets/home_screen/place_details.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

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
            child: GestureDetector(
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
            ),
          ),
        );
      }
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