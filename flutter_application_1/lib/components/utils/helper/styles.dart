import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme/colors.dart';

class AppStyles {
  static TextStyle setAppStyle(Color? color, double? fontSize, FontWeight? fontWeight, String? fontFamily) {
    return TextStyle(
      color: color ?? black,
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontFamily: fontFamily ?? "medium"
    );
  }
}