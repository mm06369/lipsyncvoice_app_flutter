

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
      print(e);
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
      print(e);
    }
  }

  signIn(String email, String password) async {
    try{
      final response = await auth.signInWithEmailAndPassword(email: email , password: password);
      print("checking");
      if (response.user != null){
        print("checked");
        return true;
      }
    } on FirebaseException catch(e){
      print(e);
      return false;
    } catch (e){
      print(e);
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
      print(e);
      return false;
    } catch (e){
      print(e);
      return false;
    }
  }

  getUserId(){
    return auth.currentUser!.uid;
  }

}