import 'package:flutter/material.dart';

import 'package:cityvista/other/enums/location_result.dart';
import 'package:cityvista/other/models/city_location.dart';
import 'package:cityvista/other/utils.dart';

import 'package:flutter_map/flutter_map.dart';

class CityvistaMap extends StatefulWidget {
  final MapController controller;

  const CityvistaMap({super.key, required this.controller});

  @override
  State<CityvistaMap> createState() => _CityvistaMapState();
}

class _CityvistaMapState extends State<CityvistaMap> {
  late Future<CityLocation> future;

  @override
  void initState() {
    future = Utils.getLocation(context);
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

        CityLocation location = snapshot.data;

        List<Marker> markers = [];

        if (location.result == LocationResult.success) {
          markers.add(
            Marker(
              point: location.coords,
              builder: (context) {
                return const Icon(
                  Icons.my_location,
                  size: 30,
                );
              }
            )
          );
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