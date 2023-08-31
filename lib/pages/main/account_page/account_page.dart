import 'package:flutter/material.dart';

import 'package:cityvista/other/constants.dart';
import 'package:cityvista/pages/main/account_page/account_settings.dart';
import 'package:cityvista/widgets/home_screen/account_page/places_view.dart';
import 'package:cityvista/widgets/home_screen/account_page/favorites_view.dart';
import 'package:cityvista/widgets/home_screen/account_page/reviews_view.dart';
import 'package:cityvista/widgets/home_screen/account_page/badges_view.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
            SizedBox(
              height: 400,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      PlacesView(),
                      FavoritesView(),
                      ReviewsView(),
                      BadgesView()
                    ],
                  ),
                ),
              ),
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
      return Image.network(user.photoURL!);
    }
  }

  String formatTime(int milliseconds) {
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    return DateFormat("dd MMMM yyyy").format(dt);
  }
}