import 'package:flutter/material.dart';

import 'package:cityvista/other/constants.dart';
import 'package:cityvista/pages/main/start_page.dart';
import 'package:cityvista/other/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: buildPfp(),
                ),
                const SizedBox(width: 10),
                Text(user.displayName!, style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ))
              ],
            ),
            const SizedBox(height: 5),
            Text("Member Since: ${
              formatTime(user.metadata.creationTime!.millisecondsSinceEpoch)
            }"),
            Expanded(
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: signOutButtonPressed,
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

  void signOutButtonPressed() {
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

  Widget buildPfp() {
    if (user.photoURL == null) {
      return const Icon(Icons.person, color: kTextColor);
    } else {
      return Image.network(user.photoURL!);
    }
  }

  String formatTime(int milliseconds) {
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    return DateFormat("dd MMMM yyyy").format(dt);
  }
}