class IpseMiningHistoryModel {
  int totalNum;
  List<List> history;
  
  IpseMiningHistoryModel.fromJson(json):
  totalNum=json['total_num'],
  history=List<List>.from(json['history']);

 
}
 

 