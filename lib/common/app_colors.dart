import 'package:flutter/material.dart';

// Updated color palette for the expense tracker app
const Color primaryColor =
    Color(0xff4CAF50); // Changed to a more financial green
const Color darkPurple =
    Color.fromARGB(255, 76, 39, 173); // Slightly adjusted for a modern feel
const Color primaryColorLight = Color(0xffA5D6A7); // Lighter green for accents
const Color primaryColorDark = Color(0xFF1B5E20); // Darker green for depth
const Color darkGreyColor =
    Color.fromARGB(255, 18, 18, 18); // Darker for better readability
const Color mediumGrey =
    Color.fromARGB(255, 66, 66, 66); // Adjusted for a softer look
const Color lightGrey =
    Color.fromARGB(255, 224, 224, 224); // Softer grey for backgrounds
const Color veryLightGrey = Color(0xFFEFEFEF); // Light background for contrast
const Color backgroundColor = darkGreyColor; // Keeping dark for a modern look
const Color whiteColor = Colors.white; // Standard white
const Color dangerColor = Colors.red; // For alerts and errors
const Color greenColor =
    Color(0xff4CAF50); // Maintaining a strong financial color
const double largeLargeSize = 100.0; // Unchanged
const Color amberColor = Colors.amber; // Unchanged

LinearGradient bgdGradient = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  tileMode: TileMode.decal,
  colors: [darkPurple, darkGreyColor], // Keeping a sophisticated gradient
  transform: GradientRotation(0),
);

LinearGradient buttonGradient = const LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    mediumGrey,
    Color.fromARGB(
        255, 100, 27, 62), // Adjusted for a vibrant button appearance
  ],
  transform: GradientRotation(0),
);
