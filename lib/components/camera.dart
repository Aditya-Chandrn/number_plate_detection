import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_plate_detection/components/button.dart';

class Camera extends StatefulWidget {
  final Function(String) captureImage;

  const Camera({super.key, required this.captureImage});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();

    _initializeCamera();
  }

  void _initializeCamera() async {
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

    setState(() {});
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
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: RotatedBox(quarterTurns: 1, child: CameraPreview(_controller)),
        ),
        SizedBox(height: 10),
        Button(name: "Capture", action: _captureImage),
      ],
    );
  }
}
