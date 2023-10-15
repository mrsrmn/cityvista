import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cityvista/other/database.dart';
import 'package:cityvista/other/models/city_review.dart';
import 'package:cityvista/other/models/profile.dart';
import 'package:cityvista/other/utils.dart';

class ReviewCard extends StatelessWidget {
  final CityReview review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder(
        future: Database().getProfile(review.author),
        builder: (context, AsyncSnapshot<Profile> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CupertinoActivityIndicator());
          }
          
          Profile profile = snapshot.data!;
          
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: buildPfp(profile.photoUrl),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 25),
                    Text("${review.rating}/5", style: const TextStyle(fontSize: 18))
                  ],
                ),
                title: Text(profile.displayName),
                subtitle: Text(Utils.formatTime(review.timestamp.millisecondsSinceEpoch)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.title, style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )),
                    const SizedBox(height: 5),
                    Text(review.description)
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }

  Widget buildPfp(String? photoUrl) {
    if (photoUrl == null) {
      return const Icon(Icons.person, size: 30);
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(photoUrl, width: 40, height: 40)
      );
    }
  }
}