class PocRegisterStatusModel {
  /// disk kib
  BigInt disk;
  BigInt pid;

  int updateTime;

  bool isStop;

  String rewardDest;
  PocRegisterStatusModel({this.disk, this.pid, this.updateTime, this.isStop});
  PocRegisterStatusModel.fromJson(json)
      : disk =BigInt.parse(json['plot_size'].toString()),
        pid = BigInt.parse(json['numeric_id'].toString()),
        updateTime = json['update_time'],
        rewardDest = json['reward_dest'],
        isStop = json['is_stop'];

  Map<String, dynamic> toJson() {
    return {
      "plot_size": disk.toString(),
      'numeric_id': pid.toString(),
      'update_time': updateTime,
      'reward_dest': rewardDest,
      'is_stop': isStop
    };
  }
}

