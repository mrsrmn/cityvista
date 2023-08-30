import 'package:flutter/material.dart';

import 'package:cityvista/widgets/home_screen/cityvista_map.dart';
import 'package:cityvista/widgets/home_screen/home_bottombar.dart';
import 'package:cityvista/widgets/home_screen/home_topbar.dart';

import 'package:flutter_map/flutter_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  child: HomeBottombar(controller: controller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
