


import 'package:flutter/material.dart';

class AddressModel {
  String address;
  String symbol;
  String activeStatus='checking'; 
  String tx; 
  AddressModel({@required this.address,@required this.symbol,@required this.tx,});
  AddressModel.fromJson(json)
      : address = json['address'],
        tx = json['tx'],
        activeStatus = json['activeStatus']??'checking',
        symbol = json['symbol'];

  AddressModel.fromList(List list)
      : address = list[0],
        activeStatus = list[1],
        tx = list[2],
        symbol = list[3]=='usdt-erc20'?'USDT':list[3].toUpperCase();

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "symbol": symbol,
      "tx": tx,
      "activeStatus": activeStatus,
    };
  }
}
