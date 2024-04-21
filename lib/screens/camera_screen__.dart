import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui;
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:lipsyncvoice_app/logic/service_helper.dart';

class Camera extends StatefulWidget {

  String language;
  Camera({super.key, this.language = 'Urdu'});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late html.VideoElement _preview;
  late html.MediaRecorder _recorder;
  late html.VideoElement _result;


  @override
  void initState() {
    print("initstate called in camera screen");
    super.initState();
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

  Future<html.MediaStream?> _openCamera() async {
    final html.MediaStream? stream = await html.window.navigator.mediaDevices
        ?.getUserMedia({'video': true, 'audio': true});
    _preview.srcObject = stream;
    return stream;
  }

  void startRecording(html.MediaStream stream) {
    _recorder = html.MediaRecorder(stream);
    _recorder.start();
    _recorder.addEventListener('stop', (event) {
      stream.getTracks().forEach((track) {
        if (track.readyState == 'live') {
          print("track stopped");
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
      print(url);

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
                final response = await ServiceHelper().runTest(bytes);
                if (response.statusCode == 200) {
                  final data = json.decode(response.body);
                  setState(() {
                    print("data: ${data['output']}");
                    // isVideoComplete = true;
                    // message = data['output'];
                    // generatedTextController.text = message;
                    // isVideoProcess = false;
                    // createHistory('combined.mpg', message);
                  });
                }
              } catch (error) {
                print(error.toString());
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: Column(
        children: [
          Container(
            width: 300,
            height: 200,
            color: Colors.blue,
            child: HtmlElementView(
              key: UniqueKey(),
              viewType: 'preview',
            ),
          ),
          Container(
            width: 300,
            height: 200,
            color: Colors.blue,
            child: HtmlElementView(
              key: UniqueKey(),
              viewType: 'result',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final html.MediaStream? stream = await _openCamera();
              startRecording(stream!);
            },
            child: Text('Start Recording'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () => stopRecording(),
            child: Text('Stop Recording'),
          ),
        ],
      ),
    );
  }
}