import 'package:flutter/material.dart';
import 'package:MindPlane/pages/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Plane',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
