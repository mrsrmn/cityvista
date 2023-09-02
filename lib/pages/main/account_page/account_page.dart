import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/constants.dart';
import 'package:cityvista/pages/main/account_page/account_settings.dart';
import 'package:cityvista/widgets/home_screen/account_page/places_view.dart';
import 'package:cityvista/widgets/home_screen/account_page/favorites_view.dart';
import 'package:cityvista/widgets/home_screen/account_page/reviews_view.dart';
import 'package:cityvista/widgets/home_screen/account_page/badges_view.dart';
import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/other/models/city_review.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with TickerProviderStateMixin {
  late final TabController tabController;

  User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Account"),
          actions: [
            IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();

                Get.to(() => AccountSettings())?.then((_) async {
                  await user.reload();
                  setState(() {
                    user = FirebaseAuth.instance.currentUser!;
                  });
                });
              },
              icon: const Icon(Icons.settings)
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircleAvatar(
                child: buildPfp()
              ),
            ),
            const SizedBox(height: 5),
            Text(user.displayName!, style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            )),
            const SizedBox(height: 5),
            Text("Member Since: ${
              formatTime(user.metadata.creationTime!.millisecondsSinceEpoch)
            }"),
            const SizedBox(height: 5),
            FutureBuilder(
              future: getProfileData(),
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                Map<String, dynamic> data = snapshot.data!;

                return tabView(
                  places: data["places"] as List<CityPlace>,
                  favorites: data["favorites"] as List<CityPlace>,
                  reviews: data["reviews"] as List<CityReview>
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildPfp() {
    if (user.photoURL == null) {
      return const Icon(
        Icons.person,
        color: kTextColor,
        size: 60,
      );
    } else {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: user.photoURL!,
        )
      );
    }
  }

  String formatTime(int milliseconds) {
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    return DateFormat("dd MMMM yyyy").format(dt);
  }

  Widget tabView({
    required List<CityPlace> places,
    required List<CityPlace> favorites,
    required List<CityReview> reviews,
  }) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.travel_explore),
              ),
              Tab(
                icon: Icon(Icons.favorite),
              ),
              Tab(
                icon: Icon(Icons.comment),
              ),
              Tab(
                icon: Icon(Icons.workspace_premium),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TabBarView(
                controller: tabController,
                children: [
                  PlacesView(places: places),
                  FavoritesView(favorites: favorites),
                  ReviewsView(reviews: reviews),
                  const BadgesView()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getProfileData() async {
    try {
      Map<String, dynamic> data = (await FirebaseFirestore.instance.collection(
        "users"
      ).doc(user.uid).get()).data()!;

      List<CityPlace> places = [];
      List<CityPlace> favorites = [];
      List<CityReview> reviews = [];

      for (var place in data["places"]) {
        places.add(CityPlace.fromJson(place));
      }

      for (var place in data["favorites"]) {
        favorites.add(CityPlace.fromJson(place));
      }

      for (var review in data["reviews"]) {
        reviews.add(CityReview.fromJson(review));
      }

      return {
        "places": places,
        "reviews": reviews,
        "favorites": favorites
      };
    } catch (e) {
      debugPrint(e.toString());

      return {
        "places": List<CityPlace>.from([]),
        "reviews": List<CityReview>.from([]),
        "favorites": List<CityPlace>.from([])
      };
    }
  }
}