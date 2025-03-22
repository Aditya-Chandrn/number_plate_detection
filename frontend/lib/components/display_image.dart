import 'dart:io';

import 'package:flutter/material.dart';
import 'package:number_plate_detection/api_calls/detect_api_call.dart';
import 'package:number_plate_detection/components/button.dart';
import 'package:number_plate_detection/pages/info.dart';

class DisplayImage extends StatefulWidget {
  final String imagePath;
  final Function() cancelCapture;

  const DisplayImage({
    super.key,
    required this.imagePath,
    required this.cancelCapture,
  });

  @override
  State<DisplayImage> createState() => DisplayImageState();
}

class DisplayImageState extends State<DisplayImage> {
  bool isLoading = false;

  void _detectVehicle() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic>? data = await detectApiCall();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (data != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Info(data: data)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Image.file(File(widget.imagePath), height: 300)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Button(name: "Retake", action: widget.cancelCapture),
            Button(name: "Confirm", action: _detectVehicle),
          ],
        ),
      ],
    );
  }
}
