import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/other/utils.dart';
import 'package:cityvista/other/models/profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addPlace(CityPlace place) async {
    Map<String, dynamic> placeMap = place.toJson();

    bool isProfanity = await Utils.checkProfanity("${place.name} ${place.description}");

    if (isProfanity) {
      throw Exception("Please remove any word from your name/description that can be offensive!");
    }

    await firestore.collection("places").doc(place.id).set(placeMap);
    await firestore.collection("users").doc(place.authorUid).update({
      "places": FieldValue.arrayUnion([placeMap])
    });
  }

  Future<Profile> getProfile(String uid) async {
    Map<String, dynamic> data = (await firestore.collection(
      "users"
    ).doc(uid).get()).data()!;

    return Profile.fromJson(data);
  }
}