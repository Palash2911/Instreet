import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWithOverlay extends StatefulWidget {
  final String stallImage;
  const CameraWithOverlay({super.key, required this.stallImage});

  @override
  State<CameraWithOverlay> createState() => _CameraWithOverlayState();
}

class _CameraWithOverlayState extends State<CameraWithOverlay> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    print(widget.stallImage);
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.medium);
      _controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container();
    }
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        CameraPreview(_controller!),
        Center(
          child: Image.network(widget.stallImage),
        )
      ],
    );
  }
}
