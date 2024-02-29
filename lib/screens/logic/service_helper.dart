

import 'dart:convert';
import 'dart:typed_data';
import "package:http/http.dart" as http;


class ServiceHelper{

  String apiURL = "http://localhost:5000/";
  String runTestAPI = "runTest";
  String addMessageAPI = "add_message";
  String authenticateAPI = 'authenticate';

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
      rethrow;
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
}