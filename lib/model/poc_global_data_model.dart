class PocGlobalDataModel {
  ///poC.netPower()
  int netPower;

  ///poC.capacityPrice()
  BigInt capacityPrice;

  /// 12s，
  int blockTime = 12000;

  PocGlobalDataModel.fromList(list)
      : netPower = list[0],
        capacityPrice =
            list[1] == null ? null : BigInt.tryParse(list[1].toString()),
        blockTime = list[2];
}
