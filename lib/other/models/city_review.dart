import 'package:cloud_firestore/cloud_firestore.dart';

class CityReview {
  final double id;
  final double rating;
  final String author;
  final Timestamp timestamp;
  final String? content;

  CityReview({
    required this.id,
    required this.rating,
    required this.author,
    required this.content,
    required this.timestamp
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "rating": rating,
      "author": author,
      "content": content,
      "timestamp": timestamp
    };
  }

  factory CityReview.fromJson(Map<String, dynamic> data) {
    return CityReview(
      id: data["id"],
      rating: data["rating"],
      author: data["author"],
      content: data["content"],
      timestamp: data["timestamp"]
    );
  }
}