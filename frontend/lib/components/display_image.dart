import 'dart:io';

import 'package:flutter/material.dart';
import 'package:number_plate_detection/components/button.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Image.file(File(widget.imagePath), height: 300)),
        const SizedBox(height: 20),
        Button(name: "Retake", action: widget.cancelCapture),
      ],
    );
  }
}
