import 'package:flutter/material.dart';

import 'package:cityvista/widgets/custom_text_field.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomeTopbar extends StatefulWidget {
  const HomeTopbar({super.key});

  @override
  State<HomeTopbar> createState() => _HomeTopbarState();
}

class _HomeTopbarState extends State<HomeTopbar> {
  final TextEditingController searchTextController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.only(top: 5),
        width: MediaQuery.of(context).size.width - 55,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              offset: const Offset(0, 1),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              offset: const Offset(1, 0),
              blurRadius: 8,
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: CustomTextField(
            controller: searchTextController,
            hintText: " Search something...",
            fontWeight: FontWeight.w700,
            fontSize: 15,
            contentPadding: 10,
          ),
        ),
      ),
    );
  }
}