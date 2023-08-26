import 'package:cityvista/pages/register/username_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/authentication.dart';
import 'package:cityvista/other/constants.dart';
import 'package:cityvista/other/enums/auth_results.dart';
import 'package:cityvista/other/utils.dart';
import 'package:cityvista/widgets/custom_text_field.dart';
import 'package:cityvista/pages/main/home_page.dart';
import 'package:cityvista/pages/main/start_page.dart';

import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SmsCodePage extends StatefulWidget {
  const SmsCodePage({super.key});

  @override
  State<SmsCodePage> createState() => _SmsCodePageState();
}

class _SmsCodePageState extends State<SmsCodePage> {
  final TextEditingController controller = TextEditingController();
  final CountdownController countdownController = CountdownController();

  Widget buttonChild = const Text(
    "Continue",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700
    )
  );
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "SMS Code",
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w700
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText: "Code",
                        controller: controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        counter: Countdown(
                          seconds: 120,
                          controller: countdownController,
                          build: (_, double time) {
                            countdownController.start();

                            return Text(
                              time.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.black
                              ),
                            );
                          },
                          onFinished: () {
                            Utils.alertPopup(false, "You have been timed out.");
                            Get.to(() => const StartPage());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    if (enabled) {
                      HapticFeedback.lightImpact();

                      countdownController.pause();

                      setState(() {
                        buttonChild = const Center(child: CupertinoActivityIndicator());
                        enabled = false;
                      });

                      AuthResults verified = await Authentication.instance.verifyOTP(controller.text);
                      if (verified == AuthResults.success) {
                        if (FirebaseAuth.instance.currentUser!.displayName == null) {
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => UsernamePage()
                              ),
                              (route) => false
                            );
                          }
                        } else {
                          Utils.alertPopup(true, "You have been signed in!");

                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const HomePage()
                              ),
                              (route) => false
                            );
                          }
                        }
                      } else {
                        String errorText;

                        if (verified == AuthResults.invalidSmsCode) {
                          errorText = "Please enter a valid SMS code.";
                        } else {
                          errorText = "There was an error while verifying your SMS code. Please try again later.";
                        }

                        Utils.alertPopup(false, errorText);

                        setState(() {
                          buttonChild = const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700
                            )
                          );
                          enabled = true;
                        });
                      }
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(kTextColor),
                  ),
                  child: buttonChild,
                )
              ]
            ),
          ),
        )
      )
    );
  }
}