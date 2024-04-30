

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lipsyncvoice_app/logic/model/history_model.dart';

class DatabaseHelper{
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance; 

  getHistory(String userId) async {
    try{
      final response = await firestore.collection('history').where('userId', isEqualTo: userId).get();
      final docs = response.docs;
      List<HistoryModel> historyList = docs.map((doc) => HistoryModel.fromJson(doc.data())).toList();
      return historyList;

    } catch (e){
      debugPrint("Error in getHistory function: $e");
      return [];
    }
  }


  Future<void> addMessage(String userId, String message) async {
    try {
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);
      await firestore.collection('history').add({
        'userId': userId,
        'message': message,
        'dateAdded': date.toString()
      });
    } catch (e) {
      debugPrint('Error in addMessage function: $e');
    }
  }

  signIn(String email, String password) async {
    try{
      final response = await auth.signInWithEmailAndPassword(email: email , password: password);
      if (response.user != null){
        return true;
      }
    } on FirebaseException catch(e){
      debugPrint('Firebase Error SignIn: ${e.code} - ${e.message}');
      return false;
    } catch (e, stackTrace){
      debugPrint('Unexpected Error SignIn: $e\n$stackTrace');
      return false;
    }
  }

  signUp(String email, String password) async {
    try{
      final response = await auth.createUserWithEmailAndPassword(email: email, password: password);
      if (response.user != null){
        return true;
      }
    } on FirebaseException catch(e){
      debugPrint('Firebase Error SignUp: ${e.code} - ${e.message}');
      return false;
    } catch (e, stackTrace){
      debugPrint('Unexpected Error SignUp: $e\n$stackTrace');
      return false;
    }
  }

  signOut() async {
    try{
      await auth.signOut();
    } on FirebaseException catch(e){
      debugPrint("Error signing out from application: ${e.toString()}");
    } catch (e) {
      debugPrint("Error signing out from application: ${e.toString()}");
    }
  }

  getUserId(){
    return auth.currentUser!.uid;
  }

}