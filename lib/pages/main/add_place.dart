import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/widgets/custom_text_field.dart';
import 'package:cityvista/other/utils.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nanoid/nanoid.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final String placeId = nanoid();
  final Reference storageRef = FirebaseStorage.instance.ref();

  List<XFile> imagesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Place"),
      ),
      body: TapRegion(
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                CustomTextField(
                  controller: nameController,
                  fontWeight: FontWeight.w700,
                  hintText: "Give it a name",
                  maxLength: 30,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  fontWeight: FontWeight.w700,
                  hintText: "Describe the experience, the atmosphere.",
                  maxLength: 400,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPhotoSelectorPressed() async {
    HapticFeedback.lightImpact();

    try {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Container(
              color: Colors.black.withOpacity(.5),
              child: const Center(child: CircularProgressIndicator())
            );
          },
        );
      }

      List<XFile>? images = await ImagePicker().pickMultiImage(
        requestFullMetadata: false
      );

      if (images.length > 5) {
        if (context.mounted) {
          Navigator.pop(context);
        }

        Utils.alertPopup(
          false,
          "You can select a maximum of 5 pictures!"
        );
        return;
      }

      if (images.isNotEmpty) {
        imagesList = [];
        imagesList.addAll(images);

        if (context.mounted) {
          Navigator.pop(context);
        }

        Utils.alertPopup(
          true,
          "Uploaded ${imagesList.length} images!"
        );

        setState(() {});
      } else {
        if (context.mounted) {
          Navigator.pop(context);
        }

        return;
      }
    } catch (exception) {
      Utils.alertPopup(
        false,
        "Couldn't upload selected images."
      );

      debugPrint(exception.toString());

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void uploadImages() async {
    if (imagesList.isNotEmpty) {
      for (var image in imagesList) {
        Reference imageRef = storageRef.child("/places/$placeId/${image.name}");
        await imageRef.putFile(File(image.path));
      }
    } else {
      return;
    }
  }
}
