import 'package:cityvista/other/enums/review_upload_result.dart';
import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/other/models/city_review.dart';
import 'package:cityvista/other/utils.dart';
import 'package:cityvista/other/models/profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addPlace(CityPlace place) async {
    Map<String, dynamic> placeMap = place.toJson();

    bool isProfanity = await Utils.checkProfanity("${place.name} ${place.description}");

    if (isProfanity) {
      throw Exception("Please remove any word from your name/description that can be offensive!");
    }

    await firestore.collection("places").doc(place.id).set(placeMap);
    await firestore.collection("users").doc(place.authorUid).update({
      "places": FieldValue.arrayUnion([placeMap])
    });
  }

  Future<ReviewUploadResult> addReview(CityReview review) async {
    Map<String, dynamic> reviewMap = review.toJson();
    bool isProfanity = await Utils.checkProfanity(
      "${review.title} ${review.description}"
    );

    double currentPlaceRating = ((await firestore.collection("places").doc(
      review.placeId
    ).get()).data()!)["rating"];

    if (!isProfanity) {
      try {
        await firestore.collection("places").doc(review.placeId).update({
          "reviews": FieldValue.arrayUnion([reviewMap]),
          "rating": (currentPlaceRating + review.rating) / 2
        });
        
        await firestore.collection("users").doc(review.author).update({
          "reviews": FieldValue.arrayUnion([reviewMap])
        });

        return ReviewUploadResult.done;
      } catch (_) {
        return ReviewUploadResult.error;
      }
    } else {
      return ReviewUploadResult.profanity;
    }
  }

  Future<CityPlace> getPlace(String id) async {
    return CityPlace.fromJson((await firestore.collection("places").doc(
      id
    ).get()).data()!);
  }

  Future<Profile> getProfile(String uid) async {
    Map<String, dynamic> data = (await firestore.collection(
      "users"
    ).doc(uid).get()).data()!;

    return Profile.fromJson(data);
  }

  Future<String> getDisplayName(String uid) async {
    Map<String, dynamic> userData = (await firestore.collection("users").doc(uid).get()).data()!;

    return userData["displayName"];
  }

  Future<bool> addToFavorite(CityPlace place) async {
    try {
      await firestore.collection("users").doc(
        FirebaseAuth.instance.currentUser!.uid
      ).update({
        "favorites": FieldValue.arrayUnion([place.toJson()])
      });

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeFromFavorite(CityPlace place) async {
    try {
      await firestore.collection("users").doc(
        FirebaseAuth.instance.currentUser!.uid
      ).update({
        "favorites": FieldValue.arrayUnion([place.toJson()])
      });

      return true;
    } catch (_) {
      return false;
    }
  }
}