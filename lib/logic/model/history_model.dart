

class HistoryModel { 
  
  String? userId; 
  String? text; 
  String? dateAdded;

  HistoryModel({this.userId, this.text, this.dateAdded}); 

  HistoryModel.fromJson(Map<String, dynamic> json) { 
    userId = json['userId']; 
    text = json['message']; 
    dateAdded = json['dateAdded']; 
  }


}
