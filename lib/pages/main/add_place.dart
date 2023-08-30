import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/widgets/custom_text_field.dart';
import 'package:cityvista/other/utils.dart';
import 'package:cityvista/widgets/home_screen/add_page/location_selector.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nanoid/nanoid.dart';
import 'package:get/get.dart';


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
  String address = "";
  bool addressSelected = false;
  GeoPoint? geoPoint;

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
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();

                      Get.to(() => LocationSelector(
                        onPicked: (pickedData) {
                          Navigator.pop(context);

                          setState(() {
                            addressSelected = true;
                            address = pickedData.address;
                            geoPoint = GeoPoint(
                              pickedData.latLong.latitude,
                              pickedData.latLong.longitude
                            );
                          });
                        }
                      ));
                    },
                    child: const Text("Select Location"),
                  )
                ),
                Text(addressSelected ? address : "No location selected."),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPhotoSelectorPressed,
                    child: const Text("Select Images")
                  ),
                ),
                const SizedBox(height: 10),
                buildImagesView(),
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
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          pageBuilder: (BuildContext context, _, __) {
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

  Future<List<String>> uploadImages() async {
    List<String> imagesUrlList = [];

    if (imagesList.isNotEmpty) {
      for (var image in imagesList) {
        Reference imageRef = storageRef.child("/places/$placeId/${image.name}");
        await imageRef.putFile(File(image.path));

        imagesUrlList.add(await imageRef.getDownloadURL());
      }
    }

    return imagesUrlList;
  }

  Widget buildImagesView() {
    if (imagesList.isEmpty) {
      return const Text("No selected images!");
    } else {
      return SizedBox(
        height: 150,
        child: ListView.builder(
          itemCount: imagesList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.file(File(imagesList[index].path)),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(99),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.8),
                              offset: const Offset(0, 1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          color: Colors.red,
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              imagesList.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      );
    }
  }
}
