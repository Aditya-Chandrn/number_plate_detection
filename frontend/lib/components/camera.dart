import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_plate_detector/components/button.dart';

class Camera extends StatefulWidget {
  final Function(String) captureImage;

  const Camera({super.key, required this.captureImage});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller.initialize();

    if (mounted) {
      await _controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (!_controller.value.isInitialized) return;
    final image = await _controller.takePicture();
    widget.captureImage(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error initializing camera"));
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RotatedBox(quarterTurns: 0, child: CameraPreview(_controller)),
              ),
              const SizedBox(height: 10),
              Button(name: "Capture", action: _captureImage),
              const SizedBox(height: 20),
            ],
          );
        }
      },
    );
  }
}
