import 'package:cityvista/other/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? fontFamily;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Widget? counter;
  final double? fontSize;
  final Color? textColor;
  final Color? hintTextColor;
  final double contentPadding;
  final FontWeight? fontWeight;
  final int? maxLines;
  final int? minLines;

  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.inputFormatters,
    this.initialValue,
    this.fontFamily,
    this.keyboardType,
    this.maxLength,
    this.counter,
    this.fontSize,
    this.textColor,
    this.hintTextColor,
    this.contentPadding = 20,
    this.fontWeight,
    this.maxLines,
    this.minLines
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      style: TextStyle(
        fontFamily: fontFamily,
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(contentPadding),
        hintText: hintText,
        counter: counter,
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: hintTextColor
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: kTextColor,
            width: 2
          )
        ),
      ),
    );
  }
}