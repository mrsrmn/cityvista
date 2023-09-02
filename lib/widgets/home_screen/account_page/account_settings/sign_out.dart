import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/pages/main/start_page.dart';
import 'package:cityvista/other/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignOut extends StatelessWidget {
  const SignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => signOutButtonPressed(context),
        child: const Text("Sign Out")
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
}