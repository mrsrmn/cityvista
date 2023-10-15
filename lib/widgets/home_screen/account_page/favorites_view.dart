import 'package:cityvista/widgets/home_screen/place_card.dart';
import 'package:flutter/material.dart';

import 'package:cityvista/other/models/city_place.dart';

class FavoritesView extends StatelessWidget {
  final List<CityPlace> favorites;

  const FavoritesView({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const Center(child: Text("You don't have any favorite places!"));
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (BuildContext context, int index) {
            return PlaceCard(place: favorites[index]);
          },
        ),
      );
    }
  }
}