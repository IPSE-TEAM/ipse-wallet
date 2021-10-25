class IpseRegisterStatusModel {
  ///miner address
  String accountId;

  String nickname;
  // where miner server locates
  String region;
  // the miner's url
  String url;
  String publicKey;

  String stashAddress;
  // capacity of data miner can store kb
  BigInt capacity;
  // price per KB every day
  BigInt unitPrice;
  // times of violations
  String violationTimes;
  // total staking = unit_price * capacity
  BigInt totalStaking;


  BigInt minerStaking;

  int createTs;
  int updateTs;

  IpseRegisterStatusModel.fromJson(json)
      : accountId = json['account_id'],
        nickname = json['nickname'],
        region = json['region'],
        url = json['url'],
        capacity = BigInt.tryParse(json['capacity'].toString()),
        unitPrice = BigInt.tryParse(json['unit_price'].toString()),
        violationTimes = json['violation_times'].toString(),
        createTs = json['create_ts'],
        updateTs = json['update_ts'],
        stashAddress = json['stash_address'],
        publicKey = json['public_key'],
        minerStaking = json['miner_staking'] == null
            ? null
            : BigInt.tryParse(json['miner_staking'].toString()),
        totalStaking = BigInt.tryParse(json['total_staking'].toString());
}
