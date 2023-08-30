import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/enums/location_result.dart';
import 'package:cityvista/other/models/city_location.dart';
import 'package:cityvista/other/utils.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:app_settings/app_settings.dart';

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
    future = Utils.getLocation();
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

        if (location.result == LocationResult.permanentlyDenied) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Location is Permanently Denied"),
                  content: const Text(
                    "If you want to see whats around you more easily, please allow in the settings."
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        AppSettings.openAppSettings(type: AppSettingsType.location);
                        Navigator.pop(context);
                      },
                      child: const Text("Open Location Settings"),
                    )
                  ],
                );
              }
            );
          });
        }

        if (location.result == LocationResult.disabled) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Location Services are Disabled"),
                  content: const Text(
                    "If you want to see whats around you more easily, please enable them in the settings."
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    )
                  ],
                );
              }
            );
          });
        }

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