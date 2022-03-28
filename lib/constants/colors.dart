import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFEE6C4D);
const kImageColor = Color(0xFF4E4187);
const kBackgroundColor = Color(0xFFF9F8FD);
const kTertiaryColor = Color(0xFF035AA6);
const kQuaternaryColor = Color(0xFFFFA41B);
const kTextColor = Colors.black;
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

Color hexStringToColor({ required String hexString }) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  final int b = int.parse(buffer.toString(), radix: 16);
  return Color(b);
}