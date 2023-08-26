import 'package:cityvista/pages/register/phone_number_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/constants.dart';
import 'package:get/get.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "assets/icon.png",
                                width: 90,
                                height: 90,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "Share the best places around town.",
                            style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 25
                            )
                          ),
                        ],
                      )
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Get.to(() => PhoneNumberPage());
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(kTextColor),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
