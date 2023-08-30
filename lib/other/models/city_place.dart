import 'package:cityvista/other/models/city_comment.dart';
import 'package:cityvista/other/models/city_review.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CityPlace {
  final String id;
  final String authorId;
  final String name;
  final String description;
  final GeoPoint geoPoint;
  final List<CityComment> comments;
  final List<CityReview> reviews;
  final List<String> images;

  CityPlace({
    required this.id,
    required this.authorId,
    required this.name,
    required this.description,
    required this.geoPoint,
    required this.comments,
    required this.reviews,
    required this.images
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "authorId": authorId,
      "name": name,
      "description": description,
      "geoPoint": geoPoint,
      "comments": comments,
      "reviews": reviews,
      "images": images
    };
  }
}