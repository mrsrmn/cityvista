import 'package:cityvista/other/models/city_review.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CityPlace {
  final String id;
  final String authorUid;
  final String name;
  final String description;
  final GeoPoint geoPoint;
  final double authorRating;
  final List<CityReview> reviews;
  final List<String> images;

  CityPlace({
    required this.id,
    required this.authorUid,
    required this.name,
    required this.description,
    required this.geoPoint,
    required this.reviews,
    required this.images,
    required this.authorRating
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "authorUid": authorUid,
      "name": name,
      "description": description,
      "geoPoint": geoPoint,
      "reviews": reviews,
      "images": images,
      "authorRating": authorRating
    };
  }
}