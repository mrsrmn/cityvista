import 'package:cityvista/other/models/city_review.dart';
import 'package:cityvista/other/enums/price_range.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CityPlace {
  final String id;
  final String authorUid;
  final String name;
  final String description;
  final GeoPoint geoPoint;
  final num rating;
  final List<CityReview> reviews;
  final List<String> images;
  final String? website;
  final String? phone;
  final String address;
  final PriceRange priceRange;

  CityPlace({
    required this.id,
    required this.authorUid,
    required this.name,
    required this.description,
    required this.geoPoint,
    required this.reviews,
    required this.images,
    required this.rating,
    required this.website,
    required this.phone,
    required this.address,
    required this.priceRange
  });

  Map<String, dynamic> toJson() {
    List<Map> mappedReviews = [];

    for (CityReview review in reviews) {
      mappedReviews.add(review.toJson());
    }

    return {
      "id": id,
      "authorUid": authorUid,
      "name": name,
      "description": description,
      "geoPoint": geoPoint,
      "reviews": mappedReviews,
      "images": images,
      "rating": rating,
      "website": website,
      "phone": phone,
      "address": address,
      "priceRange": priceRange.name
    };
  }

  factory CityPlace.fromJson(Map<String, dynamic> data) {
    List<CityReview> reviews = [];

    for (var review in data["reviews"]) {
      reviews.add(CityReview.fromJson(review));
    }

    return CityPlace(
      id: data["id"],
      authorUid: data["authorUid"],
      name: data["name"],
      description: data["description"],
      geoPoint: data["geoPoint"],
      reviews: reviews,
      images: List<String>.from(data["images"]),
      rating: data["rating"],
      website: data["website"],
      phone: data["phone"],
      address: data["address"],
      priceRange: PriceRange.values.byName(data["priceRange"])
    );
  }
}