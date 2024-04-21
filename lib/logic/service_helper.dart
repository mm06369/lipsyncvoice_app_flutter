

import 'dart:convert';
import 'dart:typed_data';
import "package:http/http.dart" as http;


class ServiceHelper{

  // String apiURL = "http://localhost:5000/";
  String apiURL = "http://119.63.132.179:5000/";
  String runTestAPI = "runTest";
  String runRomanAPI = "runRoman";
  String addMessageAPI = "add_message";
  String authenticateAPI = 'authenticate';
  String getHistoryAPI = 'get_history?user_id=';

  runTest(Uint8List videoData) async {
    try{
      final response = await http.post(
          Uri.parse(apiURL + runTestAPI),
          body: videoData,
          headers: {
            'Content-Type': 'video/mpg', 
          },
        );
        return response;
    }
    on Exception catch(error){
      print("error");
      rethrow;
    }
  }

  runRomanTest(Uint8List videoData) async {
    print('runroman called');
    try{
      final response = await http.post(
          Uri.parse(apiURL + runRomanAPI),
          body: videoData,
          headers: {
            'Content-Type': 'video/mp4', 
          },
        );
        return response;
    }
    catch(error){
      print(error);
      return {'output': "error"};
    }
  }

  addMessage(String name, String message, int userId) async {
    try{
      final response = await http.post(
          Uri.parse(apiURL + addMessageAPI),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'message': message,
            'user_id': userId
          }),
        );
        return response;
    }
    on Exception catch(error){
      rethrow;
    }
  }

  authenticate(String email, String password) async {
    try{
    final response = await http.post(Uri.parse(apiURL + authenticateAPI),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': email,
      'password': password
    }),
    );
    return response;
    }
    on Exception catch(error){
      rethrow;
    }

  }

  getHistory(int userId) async {
    try{
      final response = await http.get(Uri.parse('$apiURL$getHistoryAPI$userId'));
      return response;
    }
    on Exception catch(error){
      rethrow;
    }
  }
}