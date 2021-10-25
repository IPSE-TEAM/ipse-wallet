
import 'dart:convert';

class StakingTxData  {
 
  int blockNum = 0;

  int blockTimestamp = 0;

  String accountId = "";

  String module = "";

  String call = "";

  String hash = "";

  String txNumber = "";

  String fee = "";

  String params = "";

  int nonce;
  bool success = true;

  StakingTxData.fromJson(json):
  blockNum=json['attributes']["block_id"],
  blockTimestamp=DateTime.parse(json['attributes']["datetime"]).millisecondsSinceEpoch,
  accountId=json['attributes']["address"],
  module=json['attributes']["module_id"],
  call=json['attributes']["call_id"],
  hash='0x${json['attributes']["extrinsic_hash"]}',
  txNumber=json['id'],
  params=jsonEncode(json['attributes']["params"]),
  nonce=json['attributes']["nonce"],
  success=json['attributes']["success"]>0?true:false;
}


class StakingTxRewardData  {
 
  int blockNum = 0;

  int blockTimestamp = 0;

  String amount = "";

  String eventId = "";

  int eventIdx;

  String eventIndex;

  String extrinsicHash = "";

  int extrinsicIdx;

  String moduleId = "";

  String txNumber = "";

  String slashKton = "";

  String params = "";

  StakingTxRewardData.fromJson(json):
  blockNum=json['attributes']["block_id"],
  blockTimestamp=DateTime.parse(json['attributes']["datetime"]).millisecondsSinceEpoch,
  amount=json['attributes']["attributes"][1]["value"].toString(),
  eventId=json['attributes']["event_id"],
  eventIdx=json['attributes']["event_idx"],
  eventIndex='${json['attributes']["block_id"]}-${json['attributes']["extrinsic_idx"]}',
  extrinsicIdx=json['attributes']["extrinsic_idx"],
  moduleId=json['attributes']["module_id"],
  txNumber=json['id'],
  params=jsonEncode(json['attributes']["params"]);
}
