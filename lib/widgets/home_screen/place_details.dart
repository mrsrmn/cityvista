import 'package:cityvista/other/models/city_place.dart';
import 'package:flutter/material.dart';

class PlaceDetails extends StatelessWidget {
  final CityPlace place;

  const PlaceDetails({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.flag)
          )
        ],
      ),
    );
  }
}