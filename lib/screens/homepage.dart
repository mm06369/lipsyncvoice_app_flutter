import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lipsyncvoice_app/screens/components/page_header.dart';
import 'package:lipsyncvoice_app/screens/logic/service_helper.dart';
import 'package:lipsyncvoice_app/screens/view_history.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:universal_image_picker_web/image_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lipsyncvoice_app/components/addvid_btn.dart';
import 'package:lipsyncvoice_app/components/contact_btn.dart';
import 'package:open_file/open_file.dart';
import '../utils/global_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userId});
  final int userId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool contactPressed = false;
  bool showAdd = true;
  bool isVideoProcess = false;
  bool isVideoComplete = false;
  late String message;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration audioDuration = const Duration();
  late Duration fullDuration;
  FlutterTts flutterTts = FlutterTts();
  TextEditingController generatedTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            PageHeader(
              resetStates: resetStates,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      width: 200,
                      height: MediaQuery.sizeOf(context).height * 0.88,
                      decoration: BoxDecoration(
                          color: Globals.pagebgColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          columnAddVideoButton(),
                          const SizedBox(
                            height: 10,
                          ),
                          historyButton(),
                          const SizedBox(
                            height: 10,
                          ),
                         contactButton(),
                          const SizedBox(
                            height: 10,
                          ),
                          if (contactPressed) contactContainer(),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        if (showAdd) uploadButton(),
                        if (isVideoProcess) loadingIndicator(),
                        if (isVideoComplete) messageContainer(),
                        if (isVideoComplete) audioContainer(),
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }

  Widget contactButton() {
    return ContactButton(
        btnName: "Contact Us",
        onPressed: contactOnPress,
        isPressed: contactPressed);
  }

  Widget historyButton() {
    return AddVideoButton(
      icon: Icons.history,
      btnName: "View History",
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewHistoryPage(
                      userId: widget.userId,
                    )));
      },
    );
  }

  Widget columnAddVideoButton() {
    return AddVideoButton(
      icon: Icons.add_circle,
      btnName: "Upload Video",
      onPressed: () async {
        await ImagePickerWeb.getVideoAsBytes().then((value) => {
              setState(() {
                showAdd = false;
                isVideoProcess = true;
              }),
              uploadVideo(value!)
            });
      },
    );
  }

  Widget uploadButton() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () async {
          await ImagePickerWeb.getVideoAsBytes().then((value) => {
                setState(() {
                  showAdd = false;
                  isVideoProcess = true;
                }),
                uploadVideo(value!)
              });
        },
        icon: const Icon(Icons.add),
        label: const Text("Upload Video"),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.black)))),
      ),
    );
  }

  Widget loadingIndicator() {
    return Column(
      children: [
        const SizedBox(
          height: 40,
          width: 40,
          child: LoadingIndicator(
              indicatorType: Indicator.ballScaleMultiple,
              colors: [Colors.white, Colors.grey],
              strokeWidth: 2,
              backgroundColor: Colors.white,
              pathBackgroundColor: Colors.black),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Processing the Video",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
        ),
      ],
    );
  }

  Widget messageContainer() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (isVideoComplete)
            Text(
              "The message in the video is: ",
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
            ),
          if (isVideoComplete)
            SizedBox(
              width: 500,
              child: Text(
                message,
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }

  Widget audioContainer() {
    return Column(
      children: [
        const Text("Generated Audio"),
        if (isVideoComplete)
          const SizedBox(
            height: 10,
          ),
        IconButton(
            onPressed: () {
              _pause(!isPlaying);
            },
            icon: isPlaying
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow)),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget contactContainer() {
    return Column(
      children: [
        Text(
          "Muhammad: 03202907153",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        Text("Faraz: 03323377681",
            style: GoogleFonts.poppins(color: Colors.white)),
        Text("Ronit: 03342542450",
            style: GoogleFonts.poppins(color: Colors.white))
      ],
    );
  }

  @override
  void initState() {
    _audioPlayer.setSourceUrl("assets/audio/speech.wav");
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
      print('Audio playback completed');
    });
    _audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        audioDuration = event;
      });
    });

    super.initState();
  }

  Future<void> _speak() async {
    String text = generatedTextController.text;
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  // Future<void> _stop() async {
  //   await flutterTts.stop();
  // }

  Future<void> _pause(bool val) async {
    if (val) {
      await _speak();
      setState(() {
        isPlaying = !isPlaying;
      });
    } else {
      await flutterTts.pause();
      setState(() {
        isPlaying = !isPlaying;
      });
    }
  }

  void playAudio(bool play) {
    if (play) {
      _audioPlayer.play(UrlSource('assets/audio/speech.wav'));
      setState(() {
        isPlaying = true;
      });
    } else {
      _audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    }
  }

  resetStates() {
    setState(() {
      contactPressed = false;
      showAdd = true;
      isVideoProcess = false;
      isVideoComplete = false;
    });
  }

  contactOnPress() {
    setState(() {
      contactPressed = !contactPressed;
    });
  }

  void uploadVideo(Uint8List videoData) async {
    try {
      final response = await ServiceHelper().runTest(videoData);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isVideoComplete = true;
          message = data['output'];
          generatedTextController.text = message;
          isVideoProcess = false;
          createHistory('combined.mpg', message);
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void createHistory(String name, String message_) async {
    try {
      final response =
          await ServiceHelper().addMessage(name, message_, widget.userId);
      if (response.statusCode == 200) {
        print('Message added successfully');
      } else {
        print('Failed to add message');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
