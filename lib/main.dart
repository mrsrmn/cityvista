import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/constants.dart';
import 'package:cityvista/pages/start_page.dart';
import 'package:cityvista/firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.black,
    statusBarBrightness: Brightness.light
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LockerApp());
}

class LockerApp extends StatelessWidget {
  const LockerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cityvista",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kTextColor),
        fontFamily: "Poppins",
        useMaterial3: true
      ),
      home: const StartPage(),
    );
  }
}
