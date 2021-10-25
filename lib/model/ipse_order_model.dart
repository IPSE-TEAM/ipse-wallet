class IpseOrderModel  {
  String miner;
  // the label of this data
  String label;
  // the hash of data
  String hash;
  // the size of storing data
  int size;
  String user;
  List<MinerOrder> orders;

  /// Once one miner confirms it,
  /// this order becomes confirmed. [status]:
  ///  Created,
  ///  Confirmed,
  ///  Expired,
  ///  Deleted,
  String status;

  // last update-status timestamp
  int updateTs;

  // how long this data keep  :days
  String duration;
  IpseOrderModel.fromJson(json)
      : miner = json['miner'],
        label = json['label'],
        hash = json['hash'],
        size = json['size'],
        user = json['user'],
        orders = (json['orders'] as List)
            .map((e) => MinerOrder.fromJson(e))
            .toList(),
        status = json['status'],
        updateTs = json['update_ts'],
        duration = ((BigInt.parse(json['duration'].toString()) /
                BigInt.from(1000) /
                24 /
                60 /
                60))
            .toStringAsFixed(0);
}

class MinerOrder {
  String miner;
  // one day price = unit_price * data_length
  BigInt dayPrice;
  // total_price = day_price * days
  BigInt totalPrice;
  // last verify result
  bool verifyResult;
  // last verify timestamp
  int verifyTs;
  // confirm order timestamp
  int confirmTs;
  // use to be read data
  String url;
  MinerOrder.fromJson(json)
      : miner = json['miner'],
        dayPrice = BigInt.parse(json['day_price'].toString()),
        totalPrice = BigInt.parse(json['total_price'].toString()),
        verifyResult = json['verify_result'],
        verifyTs = json['verify_ts'],
        confirmTs = json['confirm_ts'],
        url = json['url'];
}

enum OrderStatus {
  Created,
  // Once one miner confirms it,
  // this order becomes confirmed.
  Confirmed,
  Expired,
  Deleted,
}
