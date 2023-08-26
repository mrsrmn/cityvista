import 'package:flutter/cupertino.dart';

import 'package:cityvista/other/enums/auth_results.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Authentication extends GetxController {
  static Authentication get instance => Get.find();
  var verificationId = "".obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendSMS(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      timeout: const Duration(seconds: 120),
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == "invalid-phone-number") {
          throw Exception("Invalid phone number.");
        } else if (e.code == "invalid-credential") {
          throw Exception("Invalid SMS code.");
        } else {
          throw Exception(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<AuthResults> verifyOTP(String smsCode) async {
    try {
      UserCredential credential = await auth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode
      ));

      return credential.user != null ? AuthResults.success : AuthResults.error;
    } on FirebaseAuthException catch (e, _) {
      debugPrint(e.code);

      if (e.code == "unknown") {
        return AuthResults.unknown;
      } else if (e.code == "invalid-credential") {
        return AuthResults.invalidSmsCode;
      } else {
        return AuthResults.error;
      }
    }
  }

  Future<AuthResults> reAuthenticate(String smsCode) async {
    try {
      UserCredential credential = await auth.currentUser!.reauthenticateWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId.value,
          smsCode: smsCode
      ));

      return credential.user != null ? AuthResults.success : AuthResults.error;
    } on FirebaseAuthException catch (e, _) {
      debugPrint(e.code);

      if (e.code == "unknown") {
        return AuthResults.unknown;
      } else if (e.code == "invalid-credential") {
        return AuthResults.invalidSmsCode;
      } else {
        return AuthResults.error;
      }
    }
  }
}
