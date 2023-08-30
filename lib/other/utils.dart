import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

import 'package:cityvista/bloc/register/register_bloc.dart';
import 'package:cityvista/other/enums/location_result.dart';
import 'package:cityvista/other/models/city_location.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class Utils {
  static validatePhone(String value, Emitter emit) {
    String pattern = r"^\+((?:9[679]|8[035789]|6[789]|5[90]|42|3[578]|2[1-689])|9[0-58]|8[1246]|6[0-6]|5[1-8]|4[013-9]|3[0-469]|2[70]|7|1)(?:\W*\d){0,13}\d$";
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      emit(RegisterPhoneEmpty());
    }
    else if (!regExp.hasMatch(value)) {
      emit(RegisterPhoneInvalid());
    } else {
      emit(RegisterPhoneValid());
    }
  }

  static alertPopup(bool success, String message) {
    Get.snackbar(
      success ? "Success!" : "Error!",
      message,
      colorText: Colors.black,
      icon: Icon(
        success ? Icons.verified_outlined : Icons.warning_amber,
        color: success ? Colors.green : Colors.red
      ),
      shouldIconPulse: false
    );
  }

  static Future<CityLocation> getLocation(BuildContext context) async {
    LatLng defaultLocation = const LatLng(48.52692741500706, 22.331241921397165);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
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
      }

      return CityLocation(
        result: LocationResult.disabled,
        coords: defaultLocation,
        zoom: 3
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return CityLocation(
          result: LocationResult.denied,
          coords: defaultLocation,
          zoom: 3
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
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
      }

      return CityLocation(
        result: LocationResult.permanentlyDenied,
        coords: defaultLocation,
        zoom: 3
      );
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    return CityLocation(
      result: LocationResult.success,
      coords: LatLng(currentPosition.latitude, currentPosition.longitude),
    );
  }
}