import 'package:flutter/material.dart';
import 'package:number_plate_detector/pages/home.dart';
import 'package:number_plate_detector/utils/constants.dart';

void main() {
  ApiUrls.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Plate Detector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      ),
      home: const Home(),
    );
  }
}
