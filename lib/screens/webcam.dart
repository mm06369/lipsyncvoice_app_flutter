
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Webcam extends StatefulWidget {
  
  bool recordingDone;
  Function(Uint8List)? onRecordingDone;
  Function()? onRecordingStart;
  Webcam({super.key, this.recordingDone = false, this.onRecordingDone, this.onRecordingStart});

  @override
  State<Webcam> createState() => _WebcamState();
}

class _WebcamState extends State<Webcam> {
  

  late html.VideoElement _preview;
  late html.MediaRecorder _recorder;
  late html.VideoElement _result;

  bool showWebcam = false;

  @override
  void initState() {
    super.initState();
    initalizeWebcamBrowser();
    
  }

  Future<html.MediaStream?> _openWebcam() async {
    final html.MediaStream? stream = await html.window.navigator.mediaDevices
        ?.getUserMedia({'video': true, 'audio': true});
    _preview.srcObject = stream;
    return stream;
  }

  initalizeWebcamBrowser() {
    _preview = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..width = html.window.innerWidth!
      ..height = html.window.innerHeight!;

    ui.platformViewRegistry.registerViewFactory('preview', (int _) => _preview);

    _result = html.VideoElement()
      ..autoplay = false
      ..muted = false
      ..width = html.window.innerWidth!
      ..height = html.window.innerHeight!
      ..controls = true;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('result', (int _) => _result);
  }

  void startRecording(html.MediaStream stream) {
    _recorder = html.MediaRecorder(stream);
    _recorder.start();
    _recorder.addEventListener('stop', (event) {
      stream.getTracks().forEach((track) {
        if (track.readyState == 'live') {
          debugPrint("Track Stopped");
          track.stop();
        }
      });
    });
    
    html.Blob blob = html.Blob([]);

    _recorder.addEventListener('dataavailable', (event) {
      blob = js.JsObject.fromBrowserObject(event)['data'];
    }, true);

    _recorder.addEventListener('stop', (event) {
      final url = html.Url.createObjectUrl(blob);
      _result.src = url;
      debugPrint("URL of recorded video: $url");

      html.HttpRequest.request(url, responseType: 'blob')
          .then((html.HttpRequest request) async  {
        if (request.status == 200) {
          // Convert the fetched blob into bytes
          final reader = html.FileReader();
          reader.readAsArrayBuffer(request.response);
          reader.onLoadEnd.listen((event) async {
            if (reader.readyState == html.FileReader.DONE) {
              // Convert the array buffer to bytes
              Uint8List bytes = Uint8List.fromList(reader.result as List<int>);
              try {
                if (widget.onRecordingStart != null){
                  widget.onRecordingStart!();
                }
                if (widget.onRecordingDone != null){
                  widget.onRecordingDone!(bytes);
                }
              } catch (error) {
                debugPrint(error.toString());
              }

            }
          });
        }
      });
    });
  }

  void stopRecording() => _recorder.stop();
  
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 200,
                color: Colors.grey,
                child: HtmlElementView(
                  key: UniqueKey(),
                  viewType: 'preview',
                ),
              ),
              Container(
                width: 300,
                height: 200,
                color: Colors.grey,
                child: HtmlElementView(
                  key: UniqueKey(),
                  viewType: 'result',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), // Make the button circular
                  ),
                  onPressed: () async {
                    final html.MediaStream? stream = await _openWebcam();
                    setState(() {
                      });
                    startRecording(stream!);
                  }, 
                child: Image.asset("assets/record_icon.png", width: 40, height: 40,)),
              const SizedBox(width: 10,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), // Make the button circular
                  ),
                  onPressed: () async {
                    setState(() {
                    widget.recordingDone = true;
                  });
                  stopRecording();
                  }, 
                child: Image.asset("assets/stop_btn.png", width: 40, height: 40,)),
            ],
          ),
        ],
    );
  }
}
