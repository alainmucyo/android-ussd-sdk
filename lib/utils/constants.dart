import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CustomColor {
  static const Color LIGHT_GREY = Color(0xfff7fafc);
  static const Color LIGHT_GREY_2 = Color(0xffe2e8f0);
  static const Color LIGHT_GREY_3 = Color(0xffcbd5e0);
  static const Color DARK_GREY = Color(0xff4a5568);
  static const Color SUPER_DARK_GREY = Color(0xff2d3748);
  static const Color PRIMARY = Color(0xff01A3FF);
  // static const Color PRIMARY = Color(0xff2161e7);
  static const Color ACCENT_COLOR = Color(0xff01A3FF);
  static const Color RED_COLOR = Color(0xffFF0000);
}


class Utils{
  static String validatePhone(String value) {
    String pattern = r'(^(07[8,9])[0-9]{7}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid MTN mobile number';
    }
    return "";
  }
}