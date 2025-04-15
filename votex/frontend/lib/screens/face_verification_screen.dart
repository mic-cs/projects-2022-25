import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:face_camera/face_camera.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:votex/screens/home_screen.dart';
import 'package:votex/services/api_service.dart';

class FaceVerificationScreen extends StatefulWidget {
  final String verificationId;
  const FaceVerificationScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<FaceVerificationScreen> createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  File? _capturedImage;

  late FaceCameraController controller;

  @override
  void initState() {
    controller = FaceCameraController(
      autoCapture: true,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        setState(
          () {
            _capturedImage = image;
          },
        );
      },
      onFaceDetected: (Face? face) {
        //
      },
    );
    super.initState();
  }

  Future<void> _verify(File imgFile) async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    try {
      // Call the API service to verify the face.
      final Map<String, dynamic> result = await apiService.faceVerify(
        verificationId: widget.verificationId,
        image: imgFile,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$result["verified"]')),
      );

      // Check verification result.
      if (result['verified'] == true) {
        // If verified, navigate to the next page.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Otherwise, show an error message.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Face verification failed. Please try again.')),
        );
      }
    } catch (e) {
      // Handle errors during capture or API call.
      debugPrint('Error capturing image or verifying face: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Verification'),
      ),
      body: Builder(
        builder: (context) {
          // Once the controller is initialized, display the preview.
          if (_capturedImage != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Live camera preview in a circle.
                Center(
                  child: ClipOval(
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.greenAccent, width: 4),
                        shape: BoxShape.circle,
                      ),
                      child: Image.file(
                        _capturedImage!,
                        width: double.maxFinite,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await controller.startImageStream();
                    setState(() {
                      _capturedImage = null;
                    });
                  },
                  child: const Text('Capture Again'),
                ),
                ElevatedButton(
                  onPressed: () async {},
                  child: const Text('verify'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Manual verification will be complete in 2 days'),
                      ),
                    );
                  },
                  child: const Text('request verification'),
                ),
              ],
            );
          } else {
            // Otherwise, show a loading spinner.
            return SmartFaceCamera(
              controller: controller,
              messageBuilder: (context, face) {
                if (face == null) {
                  return _message('Place your face in the camera');
                }
                if (!face.wellPositioned) {
                  return _message('Center your face in the square');
                }
                return const SizedBox.shrink();
              },
            );
          }
        },
      ),
    );
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
