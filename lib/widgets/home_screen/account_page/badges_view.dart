import 'package:cityvista/other/enums/badges/badge_type.dart';
import 'package:cityvista/other/models/profile.dart';
import 'package:flutter/material.dart';

import 'package:cityvista/other/enums/badges/profile_badges.dart';
import 'package:cityvista/other/constants.dart';
import 'package:cityvista/other/database.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BadgesView extends StatelessWidget {
  const BadgesView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Database().getProfile(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        Profile profile = snapshot.data!;

        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
          itemCount: ProfileBadges.values.length,
          itemBuilder: (BuildContext context, int index) {
            ProfileBadges currentBadge = ProfileBadges.values[index];

            int currentNumber;

            switch (currentBadge.type) {
              case BadgeType.reviews:
                currentNumber = profile.reviews.length;
              case BadgeType.places:
                currentNumber = profile.places.length;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentBadge.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
                Text(
                  currentBadge.description,
                  style: const TextStyle(
                    fontSize: 15
                  ),
                ),
                const SizedBox(height: 10),
                LinearPercentIndicator(
                  center: Text("$currentNumber/${currentBadge.count}"),
                  padding: EdgeInsets.zero,
                  animation: true,
                  barRadius: const Radius.circular(10),
                  percent: currentNumber / currentBadge.count,
                  lineHeight: 20.0,
                  animationDuration: 800,
                  progressColor: kTextColor,
                ),
              ],
            );
          }
        );
      }
    );
  }
}