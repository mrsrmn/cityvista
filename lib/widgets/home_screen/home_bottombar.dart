import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/constants.dart';
import 'package:cityvista/other/utils.dart';
import 'package:cityvista/other/models/city_location.dart';
import 'package:cityvista/pages/main/add_place.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class HomeBottombar extends StatelessWidget {
  final MapController controller;
  final Function(LatLng destLocation, double destZoom) locationSelector;

  final User user = FirebaseAuth.instance.currentUser!;

  HomeBottombar({
    super.key,
    required this.controller,
    required this.locationSelector
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.8),
              offset: const Offset(0, 1),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              offset: const Offset(1, 0),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(
              onTap: () => accountPageButtonTap(context),
              icon: buildPfp()
            ),
            const SizedBox(
              height: 30,
              width: 10,
              child: VerticalDivider(
                color: Colors.black,
                width: 2,
                thickness: 0.2,
              ),
            ),
            buildButton(
              onTap: () {
                HapticFeedback.lightImpact();
                Get.to(() => const AddPlace());
              },
              icon: Icons.add_box_rounded
            ),
            const SizedBox(
              height: 30,
              width: 10,
              child: VerticalDivider(
                color: Colors.black,
                width: 2,
                thickness: 0.2,
              ),
            ),
            buildButton(
              onTap: () => getCurrentLocation(context),
              icon: Icons.my_location
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton({
    required Function() onTap,
    required IconData icon
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(icon, color: kTextColor, size: 25),
      ),
    );
  }

  IconData buildPfp() {
    return CupertinoIcons.person_fill;
  }
  
  void getCurrentLocation(BuildContext context) async {
    HapticFeedback.lightImpact();
    CityLocation location = await Utils.getLocation(context);

    locationSelector(
      location.coords,
      15
    );
    return;
  }
  
  void accountPageButtonTap(BuildContext context) {
    HapticFeedback.lightImpact();

    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AccountPage()
      )
    ).then((_) async {
      user.reload();
      setState(() {
        user = FirebaseAuth.instance.currentUser!;
      });
    });
     */
  }
}