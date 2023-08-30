import 'package:flutter/material.dart';

import 'package:cityvista/widgets/home_screen/cityvista_map.dart';
import 'package:cityvista/widgets/home_screen/home_bottombar.dart';
import 'package:cityvista/widgets/home_screen/home_topbar.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final MapController controller = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TapRegion(
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            CityvistaMap(
              controller: controller,
            ),
            const SafeArea(
              child: HomeTopbar(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: HomeBottombar(
                    controller: controller,
                    locationSelector: (LatLng destLocation, double destZoom) => _animatedMapMove(
                      destLocation,
                      destZoom,
                      controller
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom, MapController mapController) {
    final latTween = Tween<double>(
      begin: mapController.center.latitude,
      end: destLocation.latitude
    );
    final lngTween = Tween<double>(
      begin: mapController.center.longitude,
      end: destLocation.longitude
    );
    final zoomTween = Tween<double>(
      begin: mapController.zoom,
      end: destZoom
    );

    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this
    );
    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn
    );

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation)
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
