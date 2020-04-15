import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

final safeColors = [
  Colors.deepPurple,
  Colors.green.shade500,
  Colors.indigo,
  Colors.pinkAccent.shade700,
  Colors.teal,
  Colors.purple,
  Colors.indigo.shade700,
  Colors.red.shade900,
  Colors.indigoAccent,
  Colors.black.withRed(50).withGreen(50).withBlue(50),
];

final monthNames = [
  "JAN",
  "FEB",
  "MAR",
  "APR",
  "MAY",
  "JUN",
  "JUL",
  "AUG",
  "SEP",
  "OCT",
  "NOV",
  "DEC",
];

// DataOrder: [Heading, safeColorIndex, DD, MMM, YYYY, Body]
List<List<String>> exampleTexts = [
  ["Welcome to Mind Plane.", "2", "Ages", "AGO", "", ""],
  ["Hello new user", "0", "Ages", "AGO", "", ""],
  ["Let's make this world a better place.", "3", "Ages", "AGO", "", ""],
];

// Global Working Variables
