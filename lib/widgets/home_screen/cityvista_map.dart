import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/enums/location_result.dart';
import 'package:cityvista/other/models/city_location.dart';
import 'package:cityvista/other/utils.dart';
import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/other/constants.dart';
import 'package:cityvista/pages/main/place_details/place_details.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class CityvistaMap extends StatefulWidget {
  final MapController controller;

  const CityvistaMap({super.key, required this.controller});

  @override
  State<CityvistaMap> createState() => _CityvistaMapState();
}

class _CityvistaMapState extends State<CityvistaMap> {
  late Future future;

  @override
  void initState() {
    future = Future.wait([
      Utils.getLocation(context),
      Utils.getPlaces()
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        CityLocation location = snapshot.data[0];
        List<CityPlace> places = snapshot.data[1];

        List<Marker> markers = [];

        if (location.result == LocationResult.success) {
          markers.add(
            Marker(
              point: location.coords,
              builder: (context) {
                return const Icon(
                  Icons.my_location,
                  size: 28,
                );
              }
            )
          );
        }

        for (CityPlace place in places) {
          markers.add(Marker(
            width: 40,
            height: 40,
            point: LatLng(place.geoPoint.latitude, place.geoPoint.longitude),
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.to(() => PlaceDetails(place: place));
                },
                child: Container(
                  key: const ValueKey(0),
                  padding: const EdgeInsets.all(5),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.black.withOpacity(.9)
                      : Colors.white,
                    border: Border.all(color: kTextColor),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Icon(
                    Icons.travel_explore_outlined,
                    color: kTextColor,
                  )
                ),
              );
            }
          ));
        }

        return FlutterMap(
          mapController: widget.controller,
          options: MapOptions(
            center: location.coords,
            zoom: location.zoom
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              tileBuilder: MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? darkModeTileBuilder
                  : null,
              backgroundColor: Colors.black54
            ),
            MarkerLayer(
              markers: markers,
            )
          ],
        );
      },
    );
  }
}