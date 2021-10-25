class PocMiningHistoryModel {
  BigInt totalNum;
  List<List> history;
  
  PocMiningHistoryModel.fromJson(json):
  totalNum=json['total_num']==null?null:BigInt.tryParse(json['total_num'].toString()),
  history=List<List>.from(json['history']);

 
}
 

 