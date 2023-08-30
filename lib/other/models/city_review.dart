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
}