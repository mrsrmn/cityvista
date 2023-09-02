import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/utils.dart';
import 'package:cityvista/other/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChangePfp extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser!;
  final storageRef = FirebaseStorage.instance.ref();

  ChangePfp({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => pfpEditOnTap(context),
        child: const Text("Change Profile Picture"),
      ),
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
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        selectImage(context, ImageSource.gallery);
                      },
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
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        selectImage(context, ImageSource.camera);
                      },
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

  void selectImage(BuildContext context, ImageSource source) async {
    try {
      if (context.mounted) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return Container(
              color: Colors.black.withOpacity(.5),
              child: const Center(child: CircularProgressIndicator())
            );
          },
        );
      }

      XFile? image = await ImagePicker().pickImage(
        source: source,
        requestFullMetadata: false
      );

      if (image != null) {
        CroppedFile? croppedImage = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          maxHeight: 100,
          maxWidth: 100,
          compressFormat: ImageCompressFormat.png,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: "Crop Image",
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true
            ),
            IOSUiSettings(
              title: "Crop Image",
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
              aspectRatioLockDimensionSwapEnabled: false,
              minimumAspectRatio: 1,
            ),
          ],
        );

        if (context.mounted) {
          if (croppedImage != null) {
            updatePfp(
              user: user,
              path: croppedImage.path,
              name: image.name,
              context: context
            );
          } else {
            Navigator.pop(context);
            return;
          }
        }
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }
        return;
      }
    } catch (exception) {
      Utils.alertPopup(false, "We couldn't upload your profile picture!");

      debugPrint(exception.toString());

      if (context.mounted) {
        Navigator.pop(context);
      }
      return;
    }
  }

  Future<void> updatePfp({
    required User user,
    required String path,
    required String name,
    required BuildContext context
  }) async {
    if (user.photoURL != null) {
      await FirebaseStorage.instance.refFromURL(user.photoURL!).delete();
    }

    final userRef = FirebaseFirestore.instance.collection("users").doc(
      user.uid
    );

    Reference imageRef = storageRef.child("users/${user.uid}/$name");

    await imageRef.putFile(File(path));

    String downloadUrl = await imageRef.getDownloadURL();

    user.updatePhotoURL(downloadUrl);
    userRef.update({
      "photoUrl": downloadUrl
    });

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }

    Utils.alertPopup(
      true,
      "Your profile picture has been successfully changed."
    );
  }
}