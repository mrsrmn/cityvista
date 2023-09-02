import 'package:cityvista/other/models/city_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addPlace(CityPlace place) async {
    Map<String, dynamic> placeMap = place.toJson();

    try {
      await firestore.collection("places").doc(place.id).set(placeMap);
      await firestore.collection("users").doc(place.authorUid).update({
        "places": FieldValue.arrayUnion([place.toJson()])
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}