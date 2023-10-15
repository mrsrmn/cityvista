import 'package:cityvista/other/database.dart';
import 'package:cityvista/other/enums/review_upload_result.dart';
import 'package:cityvista/other/models/city_review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cityvista/other/utils.dart';
import 'package:cityvista/other/models/city_place.dart';
import 'package:cityvista/widgets/custom_text_field.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cityvista/other/enums/price_range.dart';
import 'package:cityvista/other/constants.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AddReview extends StatefulWidget {
  final CityPlace place;
  const AddReview({super.key, required this.place});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final String reviewId = const Uuid().v1();
  final Reference storageRef = FirebaseStorage.instance.ref();
  final String authorUid = FirebaseAuth.instance.currentUser!.uid;

  List<XFile> imagesList = [];
  double currentRating = 1;
  int currentPriceRange = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Review"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Title",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              CustomTextField(
                controller: titleController,
                fontWeight: FontWeight.w700,
                hintText: "Give it a title",
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
                  onPressed: () => Utils.onPhotoSelectorPressed(
                    context,
                    setState,
                    imagesList
                  ),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () async {
                HapticFeedback.lightImpact();

                if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                  Utils.alertPopup(
                    false,
                    "Please fill the text fields!"
                  );
                  return;
                }

                Utils.showLoading(context);

                try {
                  List<String> imageUrls = await Utils.uploadImages(
                    imagesList,
                    authorUid,
                    widget.place.id,
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

                  CityReview review = CityReview(
                    id: reviewId,
                    placeId: widget.place.id,
                    rating: currentRating,
                    author: authorUid,
                    timestamp: Timestamp.now(),
                    images: imageUrls,
                    title: titleController.text,
                    description: descriptionController.text,
                    priceRange: priceRange
                  );

                  ReviewUploadResult result = await Database().addReview(review);

                  switch (result) {
                    case ReviewUploadResult.done:
                      if (mounted) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }

                      Utils.alertPopup(
                        true,
                        "Successfully added review. Thank you for your contribution!"
                      );
                    case ReviewUploadResult.error:
                      if (mounted) {
                        Navigator.pop(context);
                      }

                      Utils.alertPopup(
                        true,
                        "There was an error while uploading your review, please try again later."
                      );
                    case ReviewUploadResult.profanity:
                    if (mounted) {
                      Navigator.pop(context);
                    }

                    Utils.alertPopup(
                      true,
                      "Couldn't add review. Your review cannot contain any words that could be offensive."
                    );
                  }
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
                "Add Review",
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