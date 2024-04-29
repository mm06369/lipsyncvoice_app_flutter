

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;


class ServiceHelper{

  // String apiURL = "http://localhost:5000/";
  String apiURL = "http://119.63.132.179:5000/";
  String runTestAPI = "runTest";
  String runRomanAPI = "runRoman";

  runTest(Uint8List videoData) async {
    try{
      debugPrint("runTest API called");
      final response = await http.post(
          Uri.parse('$apiURL$runTestAPI'),
          body: videoData,
          headers: {
            'Content-Type': 'video/mpg', 
          },
        );
        return response;
    }
    on Exception catch(error){
      debugPrint("Error in runTest function: ${error.toString()}");
      rethrow;
    }
    catch(error) {
      debugPrint("Error in runTest function: ${error.toString()}");
      rethrow;
    }
  }

  runRomanTest(Uint8List videoData) async {
    try{
      debugPrint("runRoman API called");
      final response = await http.post(
          Uri.parse('$apiURL$runRomanAPI'),
          body: videoData,
          headers: {
            'Content-Type': 'video/mp4', 
          },
        );
        return response;
    }
    on Exception catch(error){
      debugPrint("Error in runRoman function: ${error.toString()}");
      rethrow;
    }
    catch(error){
      debugPrint("Error in runRoman function: ${error.toString()}");
      rethrow;
    }
  }

}