import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cityvista/other/models/city_location.dart';
import 'package:cityvista/other/utils.dart';

import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class LocationSelector extends StatelessWidget {
  final Function(PickedData pickedData) onPicked;

  LocationSelector({super.key, required this.onPicked});

  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(
      color: Colors.black
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konum Seç"),
      ),
      body: FutureBuilder(
        future: Utils.getLocation(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CupertinoActivityIndicator());
          }

          CityLocation location = snapshot.data;

          LatLong currentLocation = LatLong(location.coords.latitude, location.coords.longitude);

          return FlutterLocationPicker(
            selectLocationButtonText: "Select",
            selectLocationButtonStyle: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white)
            ),
            searchbarBorderRadius: BorderRadius.circular(20),
            searchbarInputBorder: outlineInputBorder,
            showZoomController: false,
            showContributorBadgeForOSM: true,
            contributorBadgeForOSMPositionRight: MediaQuery.of(context).size.width / 2,
            searchBarHintText: "Search a Location",
            initZoom: location.zoom,
            locationButtonsColor: Colors.black,
            locationButtonBackgroundColor: Colors.white,
            zoomButtonsBackgroundColor: Colors.black,
            zoomButtonsColor: Colors.black,
            minZoomLevel: 5,
            maxZoomLevel: 16,
            mapLanguage: "en",
            initPosition: currentLocation,
            showCurrentLocationPointer: false,
            onPicked: onPicked,
            contributorBadgeForOSMColor: Colors.white,
            contributorBadgeForOSMTextColor: Colors.black,
          );
        }
      )
    );
  }
}