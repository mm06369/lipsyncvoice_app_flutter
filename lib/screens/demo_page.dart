import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller and loop the video
    _controller = VideoPlayerController.asset('assets/demo_video_final.mp4')
      ..initialize().then((_) {
        setState(() {}); // for updating the UI when the video is ready
      })
      ..setLooping(true)
      ..play(); // Automatically play the video when initialized
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
        centerTitle: true,
      ),
      body: Center(
        child: _controller?.value.isInitialized ?? false
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
            : const CircularProgressIndicator(), // Shows a loader until the video is loaded
      ),
    );
  }
}
