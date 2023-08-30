import 'package:cityvista/other/models/city_place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPlace(CityPlace place) async {
    Map<String, dynamic> placeMap = place.toJson();

    await firestore.collection("places").doc(place.id).set(placeMap);
  }
}