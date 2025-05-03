import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:number_plate_detector/api_calls/detect.dart';
import 'package:number_plate_detector/components/button.dart';
import 'package:number_plate_detector/pages/info.dart';

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
  bool _isLoading = false;

  Future<void> _confirmImage() async {
    setState(() => _isLoading = true);

    try {
      File imageFile = File(widget.imagePath);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64String = base64Encode(imageBytes);

      final details = await detectApiCall(base64String);

      if (details != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Info(details: details)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to detect vehicle")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error processing image")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Image.file(File(widget.imagePath), height: 300)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Button(name: "Retake", action: widget.cancelCapture),
            _isLoading
                ? const CircularProgressIndicator()
                : Button(name: "Confirm", action: _confirmImage),
          ],
        ),
      ],
    );
  }
}
