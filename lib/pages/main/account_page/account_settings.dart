import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/widgets/home_screen/account_page/account_settings/change_pfp.dart';
import 'package:cityvista/widgets/home_screen/account_page/account_settings/change_username.dart';
import 'package:cityvista/widgets/home_screen/account_page/account_settings/sign_out.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AccountSettings extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser!;
  final storageRef = FirebaseStorage.instance.ref();

  AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ChangePfp(),
            ChangeUsername(),
            Expanded(
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SignOut(),
                          const SizedBox(width: 5),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                              ),
                              child: const Text(
                                "Delete Account",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return const Text("Loading App Info...");
                          }

                          PackageInfo info = snapshot.data!;

                          return Column(
                            children: [
                              const Text(
                                "Cityvista",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                                )
                              ),
                              Text("Version ${info.version} | Build ${info.buildNumber}"),
                              const Text("© Emir Sürmen, 2023")
                            ],
                          );
                        },
                      ),
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
}