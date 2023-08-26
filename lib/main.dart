import 'dart:io';

import 'package:cityvista/pages/main/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/constants.dart';
import 'package:cityvista/pages/main/start_page.dart';
import 'package:cityvista/firebase_options.dart';
import 'package:cityvista/injection_container.dart' as sl;
import 'package:cityvista/other/authentication.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
  ));

  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await sl.init();

  Get.put(Authentication());

  var currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null && currentUser.displayName != null) {
    runApp(const CityvistaApp(home: HomePage()));
  } else {
    runApp(const CityvistaApp(home: StartPage()));
  }
}

class CityvistaApp extends StatelessWidget {
  final Widget home;

  const CityvistaApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Cityvista",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kTextColor),
        fontFamily: "Poppins",
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
