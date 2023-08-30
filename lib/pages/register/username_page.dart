import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/bloc/username/username_bloc.dart';
import 'package:cityvista/injection_container.dart';
import 'package:cityvista/widgets/custom_text_field.dart';
import 'package:cityvista/other/constants.dart';
import 'package:cityvista/pages/main/home_page.dart';
import 'package:cityvista/other/utils.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsernamePage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final UsernameBloc bloc = sl<UsernameBloc>();
  final Widget initialChild = const Text(
    "Let's start!",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700
    )
  );

  UsernamePage({super.key});

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Username",
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w700
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Text(
                        "You can change it anytime",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        hintText: "Type in an username",
                        controller: controller,
                        keyboardType: TextInputType.text,
                        maxLength: 14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    bloc.add(
                      SetUsernameOfUser(
                        username: controller.text
                      )
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(kTextColor),
                  ),
                  child: BlocBuilder(
                    bloc: bloc,
                    builder: (BuildContext context, UsernameState state) {
                      if (state is UsernameLoading) {
                        return const Center(child: CupertinoActivityIndicator(color: Colors.white));
                      } else if (state is UsernameSetError) {
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          Utils.alertPopup(false, state.message);
                        });

                        return initialChild;
                      } else if (state is UsernameSetSuccess) {
                        final userRef =  FirebaseFirestore.instance.collection("users").doc(
                          FirebaseAuth.instance.currentUser!.uid
                        );
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Utils.alertPopup(true, "You are ready to go!");
                        });

                        userRef.set({
                          "phone": FirebaseAuth.instance.currentUser!.phoneNumber!,
                          "displayName": controller.text,
                          "favorites": [],
                          "reviews": [],
                          "places": []
                        });

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const HomePage()
                            ),
                            (route) => false
                          );
                        });

                        return initialChild;
                      }

                      return initialChild;
                    }
                  ),
                )
              ]
            )
          ),
        ),
      ),
    );
  }
}