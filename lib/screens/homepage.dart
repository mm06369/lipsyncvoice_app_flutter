import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart';
import 'package:lipsyncvoice_app/components/custom_message.dart';
import 'package:lipsyncvoice_app/components/language_toggle.dart';
import 'package:lipsyncvoice_app/components/page_header.dart';
import 'package:lipsyncvoice_app/logic/database_helper.dart';
import 'package:lipsyncvoice_app/logic/service_helper.dart';
import 'package:lipsyncvoice_app/screens/camera_screen__.dart';
import 'package:lipsyncvoice_app/screens/view_history.dart';
import 'package:lipsyncvoice_app/screens/webcam.dart';
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
  final String userId;

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
  String languageSelected = "None";
  // bool recordingDone = false;
  bool showWebcam = false;

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
              isHomepage: true,
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
                        if (showWebcam)
                          Webcam(
                            onRecordingDone: languageSelected == 'Urdu' ? uploadurduVideo : uploadenglishVideo,
                            onRecordingStart: onProcessStart,
                          ),
                        const SizedBox(height: 10,),
                        if (showAdd && !showWebcam)
                          LanguageToggle(
                            btnSelected: "None",
                            onPressed: updateLanguage,
                          ),
                        if (showAdd && !showWebcam)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              uploadButton(),
                              recordingButton(),
                            ],
                          ),
                        if (isVideoProcess) loadingIndicator(),
                        if (isVideoComplete) customMessageContainer(),
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

  onProcessStart(){
    setState(() {
      isVideoComplete = false;
      isVideoProcess = true;
    });
  }

  getMessage(String message_){
    setState(() {
          isVideoComplete = true;
          message = message_;
          generatedTextController.text = message;
          isVideoProcess = false;
        });
  }

  void updateLanguage(String language) {
    languageSelected = language;
    print(language);
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
        await uploadVideoLogic();
      },
    );
  }

  uploadVideoLogic() async {
    if (languageSelected == 'None') {
      createDialog();
    } else {
      final video = await ImagePickerWeb.getVideoAsBytes();
      setState(() {
        showAdd = false;
        isVideoProcess = true;
      });
      if (languageSelected == 'Urdu') {
        uploadurduVideo(video!);
      } else if (languageSelected == 'English') {
        uploadenglishVideo(video!);
      }
    }
  }

  Widget uploadButton() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () async {
          await uploadVideoLogic();
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

  Widget recordingButton() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (languageSelected == 'None') {
            createDialog();
          } else {
            setState(() {
              showWebcam = true;
            });
          }
        },
        icon: const Icon(Icons.record_voice_over),
        label: const Text("Record Video"),
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

  Widget customMessageContainer(){
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        Text(
              "The person in the video is saying: ",
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
            ),
          const SizedBox(height: 5,),
         CustomMessageContainer(message: message),
       ],
     );
  }

  Widget audioContainer() {
    return Column(
      children: [
        const SizedBox(height: 20,),
        const Text("Generated Audio", style: TextStyle(fontSize: 25),),
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
    return const Column(
      children: [
        Text(
          "If you have any queries, contact us at: ",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          "lipsynvoice.fyp@gmail.com",
          style: TextStyle(color: Colors.red),
        )
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
      languageSelected = 'None';
      showWebcam = false;
      contactPressed = false;
      showAdd = true;
      isVideoProcess = false;
      isVideoComplete = false;
      // recordingDone = false;
    });
  }

  contactOnPress() {
    setState(() {
      contactPressed = !contactPressed;
    });
  }

  void uploadenglishVideo(Uint8List videoData) async {
    try {
      final response = await ServiceHelper().runTest(videoData);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await DatabaseHelper().addMessage(widget.userId, data['output']);
        setState(() {
          isVideoComplete = true;
          message = data['output'];
          generatedTextController.text = message;
          isVideoProcess = false;
          // createHistory('combined.mpg', message);
        });
      }
      else if (response.statusCode != 200){
        setState(() {
          isVideoComplete = true;
          message = "Was not able to determine what the person was saying";
          generatedTextController.text = message;
          isVideoProcess = false;
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  void uploadurduVideo(Uint8List videoData) async {
    print("urdu video uploaded -> uploadurduVideo called");
      //  await Future.delayed(Duration(seconds: 2));
      //  await DatabaseHelper().addMessage(widget.userId, "chai");
      //  setState(() {
      //     isVideoComplete = true;
      //     message = 'chai';
      //     generatedTextController.text = message;
      //     isVideoProcess = false;
      //   });
    try {
      final response = await ServiceHelper().runRomanTest(videoData);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data['output']);
        await DatabaseHelper().addMessage(widget.userId, data['output']);
        setState(() {
          isVideoComplete = true;
          message = data['output'];
          generatedTextController.text = message;
          isVideoProcess = false;
        });
      }
      else if (response.statusCode != 200){
        setState(() {
          isVideoComplete = true;
          message = "Error: Was not able to determine what the person was saying";
          generatedTextController.text = message;
          isVideoProcess = false;
        });
      }
    } catch (error) {
      setState(() {
          isVideoComplete = true;
          message = "Error: Was not able to determine what the person was saying";
          generatedTextController.text = message;
          isVideoProcess = false;
        });
      print(error.toString());
    }
  }


  createDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: const EdgeInsets.all(20),
          surfaceTintColor: Colors.black,
          backgroundColor: Colors.white,
          title: const Center(
              child: Text(
            "Select a language first!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
