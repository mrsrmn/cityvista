import 'package:flutter/material.dart';

import 'package:cityvista/bloc/register/register_bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:get/get.dart';

class Utils {
  static validatePhone(String value, Emitter emit) {
    String pattern = r"^\+((?:9[679]|8[035789]|6[789]|5[90]|42|3[578]|2[1-689])|9[0-58]|8[1246]|6[0-6]|5[1-8]|4[013-9]|3[0-469]|2[70]|7|1)(?:\W*\d){0,13}\d$";
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      emit(RegisterPhoneEmpty());
    }
    else if (!regExp.hasMatch(value)) {
      emit(RegisterPhoneInvalid());
    } else {
      emit(RegisterPhoneValid());
    }
  }

  static alertPopup(bool success, String message) {
    Get.snackbar(
      success ? "Success!" : "Error!",
      message,
      colorText: Colors.black,
      icon: Icon(
        success ? Icons.verified_outlined : Icons.warning_amber,
        color: success ? Colors.green : Colors.red
      ),
      shouldIconPulse: false
    );
  }
}