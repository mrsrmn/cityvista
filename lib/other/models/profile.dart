import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/other/models/city_review.dart';

class Profile {
  final String phone;
  final String displayName;
  final List<CityPlace> favorites;
  final List<CityReview> reviews;
  final String? photoUrl;
  final List<CityPlace> places;

  Profile({
    required this.phone,
    required this.displayName,
    required this.favorites,
    required this.reviews,
    required this.places,
    required this.photoUrl
  });

  Map<String, dynamic> toJson() {
    List<Map> mappedReviews = [];
    List<Map> mappedFavorites = [];
    List<Map> mappedPlaces = [];

    for (CityReview review in reviews) {
      mappedReviews.add(review.toJson());
    }

    for (CityPlace place in places) {
      mappedPlaces.add(place.toJson());
    }

    for (CityPlace place in favorites) {
      mappedFavorites.add(place.toJson());
    }

    return {
      "phone": phone,
      "displayName": displayName,
      "favorites": mappedFavorites,
      "reviews": mappedReviews,
      "places": mappedPlaces,
      "photoUrl": photoUrl
    };
  }

  factory Profile.fromJson(Map<String, dynamic> data) {
    List<CityReview> reviews = [];
    List<CityPlace> places = [];
    List<CityPlace> favorites = [];

    for (var review in data["reviews"]) {
      reviews.add(CityReview.fromJson(review));
    }

    for (var place in data["places"]) {
      places.add(CityPlace.fromJson(place));
    }

    for (var place in data["favorites"]) {
      favorites.add(CityPlace.fromJson(place));
    }

    return Profile(
      phone: data["phone"],
      displayName: data["displayName"],
      favorites: favorites,
      reviews: reviews,
      places: places,
      photoUrl: data["photoUrl"]
    );
  }
}