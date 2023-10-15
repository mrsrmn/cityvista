import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/price_range.dart';

class CityReview {
  final String id;
  final String placeId;
  final num rating;
  final String author;
  final List<String> images;
  final Timestamp timestamp;
  final String title;
  final String description;
  final PriceRange priceRange;

  CityReview({
    required this.id,
    required this.placeId,
    required this.rating,
    required this.author,
    required this.timestamp,
    required this.images,
    required this.title,
    required this.description,
    required this.priceRange
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "placeId": placeId,
      "rating": rating,
      "author": author,
      "images": images,
      "timestamp": timestamp,
      "title": title,
      "description": description,
      "priceRange": priceRange.name
    };
  }

  factory CityReview.fromJson(Map<String, dynamic> data) {
    return CityReview(
      id: data["id"],
      placeId: data["placeId"],
      rating: data["rating"],
      author: data["author"],
      images: List<String>.from(data["images"]),
      timestamp: data["timestamp"],
      title: data["title"],
      description: data["description"],
      priceRange: PriceRange.values.byName(data["priceRange"])
    );
  }
}