class PocStakingInfoModel {

  String miner;


  int minerProportion;


  BigInt totalStaking;

  BigInt minerStaking;


  BigInt disk;


  bool isStop;


  List<PocStakingInfoOthers> others;
  PocStakingInfoModel(
      {this.miner, this.minerProportion, this.totalStaking, this.others});
  PocStakingInfoModel.fromJson(json)
      : miner = json['miner'],
        minerProportion = json['miner_proportion'],
        totalStaking = BigInt.tryParse(json['total_staking'].toString()),
        minerStaking =json['miner_staking']==null?null: BigInt.tryParse(json['miner_staking'].toString()),
        disk =json['plot_size']==null?null: BigInt.parse(json['plot_size'].toString()),
        isStop =json['is_stop']==null?null: json['is_stop'],
        others =(json['others'] as List).map((e)=> PocStakingInfoOthers.fromList(e)).toList();

  Map<String, dynamic> toJson() {
    return {
      "miner": miner,
      'miner_proportion': minerProportion,
      'total_staking': totalStaking,
      'others': others
    };
  }
}

class PocStakingInfoOthers {
 
  String staker;


  BigInt amount;


  BigInt reserved;

  PocStakingInfoOthers.fromList(List list)
      : staker = list[0],
        amount = BigInt.tryParse(list[1].toString()),
        reserved = BigInt.tryParse(list[2].toString());
}
