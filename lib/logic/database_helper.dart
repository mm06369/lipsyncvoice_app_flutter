

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseHelper{
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUser(String name, String email, String password) async {
    try {
      await firestore.collection('users').add({
        'name': name,
        'email': email,
        'password': password
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addMessage(String userId, String message) async {
    try {
      await firestore.collection('history').add({
        'userId': userId,
        'message': message
      });
    } catch (e) {
      print(e);
    }
  }

}