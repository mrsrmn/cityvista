import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/pages/main/start_page.dart';
import 'package:cityvista/other/utils.dart';
import 'package:cityvista/other/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AccountSettings extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser!;

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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => pfpEditOnTap(context),
                child: const Text("Change Profile Picture"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Change Username"),
              ),
            ),
            Expanded(
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => signOutButtonPressed(context),
                          child: const Text("Sign Out")
                        ),
                      ),
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

  void signOutButtonPressed(BuildContext context) {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("You can sign back in any time. Your data won't be deleted."),
          actions: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("No"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Utils.showLoading(context);

                      FirebaseAuth.instance.signOut().then((_) {
                        Navigator.pop(context);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StartPage()
                          ),
                          (route) => false
                        );
                      });
                    },
                    child: const Text("Yes"),
                  ),
                ),
              ],
            )
          ],
        );
      }
    );
  }

  void pfpEditOnTap(BuildContext context) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 160,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(kTextColor),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text(
                        "Select from Camera Roll",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(kTextColor),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text(
                        "Take with Camera",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}