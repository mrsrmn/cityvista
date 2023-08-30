import 'package:cloud_firestore/cloud_firestore.dart';

class CityComment {
  final String id;
  final String author;
  final String content;
  final Timestamp timestamp;
  final List<String> images;

  CityComment({
    required this.id,
    required this.author,
    required this.content,
    required this.timestamp,
    required this.images
  });
}