
class TransferData {

  int blockNum = 0;

  int blockTimestamp = 0;

  String extrinsicIndex = "";

  String fee = "";

  String from = "";
  String to = "";
  BigInt amount ;
  // String token = "";
  String hash = "";
  String module = "balances";
  bool success = true;

  TransferData.fromJson(json):
  blockNum=json['attributes']["block_id"],
  blockTimestamp=DateTime.parse(json['attributes']["datetime"]).millisecondsSinceEpoch,
  extrinsicIndex=json['id'],
  from=json['attributes']["sender"]["attributes"]["address"],
  to=json['attributes']["destination"]["attributes"]["address"],
  amount=BigInt.parse(json['attributes']["value"].toString().replaceAll(RegExp(r"\.0+$"), "")),
  hash=json['attributes']['hash'];
}
