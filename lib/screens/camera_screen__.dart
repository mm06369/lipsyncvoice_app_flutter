import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool isCameraOn = true;

  getCameraAndInitialize() async {
    List<CameraDescription> cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void startRecording() async {
    if (!controller.value.isRecordingVideo) {
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String videoDirectory = '${appDirectory.path}/Videos';
      await Directory(videoDirectory).create(recursive: true);
      final String filePath = '$videoDirectory/${DateTime.now()}.mp4';

      try {
        await controller.startVideoRecording(
          onAvailable: (image) {
            print(image.toString());
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }

  void stopRecording() async {
    if (controller.value.isRecordingVideo) {
      try {
        await controller.stopVideoRecording();
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCameraAndInitialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text("Camera")),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (isCameraOn)
              Center(
                child: SizedBox(
                  width: 600,
                  height: 300,
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isCameraOn = !isCameraOn;
                });
              },
              child: Text(isCameraOn ? "Turn Camera Off" : "Turn Camera On"),
            ),
            ElevatedButton(
              onPressed: () {
                if (isCameraOn) {
                  startRecording();
                } else {
                  stopRecording();
                }
              },
              child: Text(isCameraOn ? "Record" : "Stop Recording"),
            ),
          ],
        ),
      ),
    );
  }
}
