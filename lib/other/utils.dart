import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/bloc/register/register_bloc.dart';
import 'package:cityvista/other/enums/location_result.dart';
import 'package:cityvista/other/models/city_location.dart';
import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/other/enums/price_range.dart';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_settings/app_settings.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

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

  static showLoading(BuildContext context) {
    if (context.mounted) {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (BuildContext context, _, __) {
          return Container(
            color: Colors.black.withOpacity(.5),
            child: const Center(child: CircularProgressIndicator())
          );
        },
      );
    }
  }

  static Future<List<CityPlace>> getPlaces() async {
    List<CityPlace> places = [];
    List data = (await FirebaseFirestore.instance.collection("places").get()).docs;

    for (QueryDocumentSnapshot<Map<String, dynamic>> place in data) {
      places.add(CityPlace.fromJson(place.data()));
    }

    return places;
  }

  static Widget buildPlaceStars(CityPlace place) {
    Widget stars = const Text("Loading Rating");
    num rating = place.rating;
    int reviewCount = place.reviews.length + 1;

    if (1 <= rating && rating < 2) {
      stars = const Row(
        children: [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
        ],
      );
    } else if (2 <= rating && rating < 3) {
      stars = const Row(
        children: [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
        ],
      );
    } else if (3 <= rating && rating < 4) {
      stars = const Row(
        children: [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.grey),
          Icon(Icons.star, color: Colors.grey),
        ],
      );
    } else if (4 <= rating && rating < 5) {
      stars = const Row(
        children: [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.grey),
        ],
      );
    } else {
      stars = const Row(
        children: [
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
          Icon(Icons.star, color: Colors.orange),
        ],
      );
    }

    return Row(
      children: [
        stars,
        const SizedBox(width: 5),
        Text("($reviewCount)", style: const TextStyle(fontSize: 18))
      ],
    );
  }

  static Widget buildPriceRange(CityPlace place) {
    switch (place.priceRange) {
      case PriceRange.one:
        return const Row(
          children: [
            SizedBox(
              width: 12,
              height: 24,
              child: Icon(CupertinoIcons.money_dollar, color: Colors.green)
            ),
            SizedBox(
              width: 15,
              height: 24,
              child: Icon(CupertinoIcons.money_dollar, color: Colors.grey)
            ),
            SizedBox(
              width: 15,
              height: 24,
              child: Icon(CupertinoIcons.money_dollar, color: Colors.grey)
            ),
          ],
        );
      case PriceRange.two:
        return const Row(
          children: [
            SizedBox(
              width: 15,
              height: 24,
              child: Icon(CupertinoIcons.money_dollar, color: Colors.green)
            ),
            SizedBox(
              width: 15,
              height: 24,
              child: Icon(CupertinoIcons.money_dollar, color: Colors.green)
            ),
            SizedBox(
              width: 15,
              height: 24,
              child: Icon(CupertinoIcons.money_dollar, color: Colors.grey)
            ),
          ],
        );
      case PriceRange.three:
        return const Row(
          children: [
            SizedBox(
              width: 15,
              height: 24,
              child: Icon(CupertinoIcons.money_dollar, color: Colors.green)
            ),
            SizedBox(
              width: 15,
              height: 24,
              child: Icon(CupertinoIcons.money_dollar, color: Colors.green)
            ),
            SizedBox(
              width: 15,
              height: 24,
              child: Icon(CupertinoIcons.money_dollar, color: Colors.green)
            ),
          ],
        );
    }
  }

  static Future<bool> checkProfanity(String text) async {
    var request = await http.get(
      Uri.parse("https://fuk.ai/detect-hatespeech?input=$text&eliminate_profanity=false"),
      headers: {
        "Authorization": "Token 9d65206e42b05a8464e32b206f245ab64cd34874d5a5602f61b7f486a24faf89"
      }
    );

    if (request.statusCode != 200) {
      return true;
    }


    if (double.parse(jsonDecode(request.body)["result"]["probability"].toString()) > 70) {
      return true;
    }

    return false;
  }

  static void onPhotoSelectorPressed(
    BuildContext context,
    StateSetter setState,
    List<XFile> imagesList
  ) async {
    HapticFeedback.lightImpact();

    try {
      if (context.mounted) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          pageBuilder: (BuildContext context, _, __) {
            return Container(
              color: Colors.black.withOpacity(.5),
              child: const Center(child: CircularProgressIndicator())
            );
          },
        );
      }

      List<XFile>? images = await ImagePicker().pickMultiImage(
          requestFullMetadata: false
      );

      if (images.length > 5) {
        if (context.mounted) {
          Navigator.pop(context);
        }

        Utils.alertPopup(
          false,
          "You can select a maximum of 5 pictures!"
        );
        return;
      }

      if (images.isNotEmpty) {
        imagesList.addAll(images);

        if (context.mounted) {
          Navigator.pop(context);
        }

        Utils.alertPopup(
            true,
            "Uploaded ${images.length} images!"
        );

        setState(() {});
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }

        return;
      }
    } catch (exception) {
      Utils.alertPopup(
        false,
        exception.toString()
      );

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  static Future<List<String>> uploadImages(
    List<XFile> imagesList,
    String authorUid,
    String placeId,
    Reference storageRef
  ) async {
    List<String> imagesUrlList = [];

    if (imagesList.isNotEmpty) {
      for (var image in imagesList) {
        Reference imageRef = storageRef.child("/places/$authorUid/$placeId/${image.name}");
        TaskSnapshot task = await imageRef.putData(await image.readAsBytes());

        imagesUrlList.add(await task.ref.getDownloadURL());
      }
    }

    return imagesUrlList;
  }

  static Widget buildImagesView(List<XFile> imagesList, StateSetter setState) {
    if (imagesList.isEmpty) {
      return const Text("No images selected.");
    } else {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          itemCount: imagesList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.file(File(imagesList[index].path)),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(99),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.8),
                              offset: const Offset(0, 1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          color: Colors.red,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              imagesList.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      );
    }
  }

  static String formatTime(int milliseconds) {
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    return DateFormat("dd MMMM yyyy").format(dt);
  }
}