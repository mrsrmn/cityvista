import 'package:cityvista/other/enums/price_range.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/widgets/custom_text_field.dart';
import 'package:cityvista/other/utils.dart';
import 'package:cityvista/widgets/home_screen/add_page/location_selector.dart';
import 'package:cityvista/other/constants.dart';
import 'package:cityvista/other/database.dart';
import 'package:cityvista/other/models/city_place.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final String placeId = const Uuid().v1();
  final Reference storageRef = FirebaseStorage.instance.ref();
  final String authorUid = FirebaseAuth.instance.currentUser!.uid;

  List<XFile> imagesList = [];
  String address = "";
  bool addressSelected = false;
  GeoPoint? geoPoint;
  double currentRating = 1;
  int currentPriceRange = 1;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                CustomTextField(
                  controller: nameController,
                  fontWeight: FontWeight.w700,
                  hintText: "Give it a name",
                  maxLength: 30,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                CustomTextField(
                  controller: descriptionController,
                  fontWeight: FontWeight.w700,
                  hintText: "Describe the experience, the atmosphere",
                  maxLength: 400,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 2,
                ),
                const Text(
                  "How was the experience?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    currentRating = rating;
                  },
                ),
                const SizedBox(height: 5),
                const Text(
                  "Price Range",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                RatingBar.builder(
                  initialRating: 2,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 3,
                  itemBuilder: (context, _) => const Icon(
                    Icons.attach_money,
                    color: Colors.green,
                    size: 12,
                  ),
                  onRatingUpdate: (priceRange) {
                    currentPriceRange = priceRange.toInt();
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  "Website (optional)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                CustomTextField(
                  controller: websiteController,
                  fontWeight: FontWeight.w700,
                  hintText: "https://example.com",
                  keyboardType: TextInputType.url,
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Phone Number (optional)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                CustomTextField(
                  controller: phoneController,
                  fontWeight: FontWeight.w700,
                  hintText: "Phone Number",
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    PhoneInputFormatter(allowEndlessPhone: false)
                  ],
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
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
                const SizedBox(height: 15),
                const Text(
                  "Images (optional)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Utils.onPhotoSelectorPressed,
                    child: const Text("Select Images")
                  ),
                ),
                Utils.buildImagesView(
                  imagesList,
                  setState
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () async {
                HapticFeedback.lightImpact();

                if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
                  Utils.alertPopup(
                    false,
                    "Please fill the text fields!"
                  );
                  return;
                }

                if (geoPoint == null) {
                  Utils.alertPopup(
                    false,
                    "Please select a location!"
                  );
                  return;
                }

                Utils.showLoading(context);

                try {
                  List<String> imageUrls = await Utils.uploadImages(
                    imagesList,
                    authorUid,
                    placeId,
                    storageRef
                  );

                  PriceRange priceRange = PriceRange.one;

                  switch (currentPriceRange) {
                    case 1:
                      priceRange = PriceRange.one;
                    case 2:
                      priceRange = PriceRange.two;
                    case 3:
                      priceRange = PriceRange.three;
                  }

                  await Database().addPlace(CityPlace(
                    id: placeId,
                    authorUid: authorUid,
                    name: nameController.text,
                    description: descriptionController.text,
                    geoPoint: geoPoint!,
                    rating: currentRating,
                    website: websiteController.text,
                    phone: phoneController.text,
                    reviews: [],
                    images: imageUrls,
                    address: address,
                    priceRange: priceRange
                  ));

                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }

                  Utils.alertPopup(
                    true,
                    "Successfully added place. Thank you for your contribution!"
                  );
                } catch (e) {
                  Utils.alertPopup(
                    false,
                    e.toString()
                  );

                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(kTextColor),
              ),
              child: const Text(
                "Add Place",
                style: TextStyle(
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
