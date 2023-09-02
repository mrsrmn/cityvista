import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/widgets/home_screen/account_page/account_settings/change_pfp.dart';
import 'package:cityvista/widgets/home_screen/account_page/account_settings/change_username.dart';
import 'package:cityvista/widgets/home_screen/account_page/account_settings/sign_out.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
                  child: Row(
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}