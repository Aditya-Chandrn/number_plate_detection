import 'package:flutter/material.dart';
import 'package:number_plate_detection/components/camera.dart';
import 'package:number_plate_detection/components/display_image.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Click Picture")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child:
            imagePath == null
                ? Camera(
                  captureImage:
                      (String path) => setState(() {
                        imagePath = path;
                      }),
                )
                : DisplayImage(
                  imagePath: imagePath!,
                  cancelCapture:
                      () => setState(() {
                        imagePath = null;
                      }),
                ),
      ),
    );
  }
}
