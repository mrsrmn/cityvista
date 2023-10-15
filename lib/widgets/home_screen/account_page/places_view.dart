import 'package:flutter/material.dart';

import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/widgets/home_screen/place_card.dart';

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
            child: PlaceCard(place: place),
          ),
        );
      }
    );
  }
}