import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_horoscopo/theme/custom_colors.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: CustomColors.backgroundApp,
      scaffoldBackgroundColor: CustomColors.backgroundApp,
      backgroundColor: CustomColors.backgroundApp,
      appBarTheme: AppBarTheme(
        backgroundColor: CustomColors.backgroundApp,
        elevation: 0,
      ),
    );
  }
}
