import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipsewallet/model/ipse_mining_history_model.dart';
import 'package:ipsewallet/model/ipse_order_model.dart';
import 'package:ipsewallet/model/ipse_register_status_model.dart';
import 'package:ipsewallet/model/poc_mining_history_model.dart';
import 'package:ipsewallet/model/poc_register_status_model.dart';
import 'package:ipsewallet/model/poc_staking_info_model.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';

class ApiIpse {
  ApiIpse(this.apiRoot);

  final Api apiRoot;
  final store = globalAppStore;


  Future<void> fetchIpseRegisterStatus() async {
    String addr = store.account.currentAccount.address;
    if (addr != null && addr.isNotEmpty) {
      try {
        var res = await apiRoot.evalJavascript('ipse.fetchIpseMiner("$addr")');
        if (res != null) {
          IpseRegisterStatusModel data = IpseRegisterStatusModel.fromJson(res);
          store.ipse.setIpseRegisterStatus(data);
        } else {
          store.ipse.setIpseRegisterStatus(null);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }


  Future<void> fetchPocRegisterStatus() async {
    String addr = store.account.currentAccount.address;
    if (addr != null && addr.isNotEmpty) {
      try {
        var res = await apiRoot
            .evalJavascript('api.query.pocStaking.diskOf("$addr")');
        if (res != null) {
          PocRegisterStatusModel data = PocRegisterStatusModel.fromJson(res);
          store.ipse.setPocRegisterStatus(data);
        } else {
          store.ipse.setPocRegisterStatus(null);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }


  Future<PocRegisterStatusModel> fetchPocMinerRegisterStatus(
      String addr) async {
    if (addr != null && addr.isNotEmpty) {
      try {
        var res = await apiRoot
            .evalJavascript('api.query.pocStaking.diskOf("$addr")');
        if (res != null) {
          PocRegisterStatusModel data = PocRegisterStatusModel.fromJson(res);
          return data;
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
    return null;
  }


  Future<void> fetchPocStakingInfo() async {
    String addr = store.account.currentAccount.address;

    if (addr != null && addr.isNotEmpty) {
      try {
        var res = await apiRoot
            .evalJavascript('api.query.pocStaking.stakingInfoOf("$addr")');
        print("stakingInfoOf");
        print(res);
        if (res != null) {
          PocStakingInfoModel data = PocStakingInfoModel.fromJson(res);
          store.ipse.setPocStakingInfo(data);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }

  
  Future<PocStakingInfoModel> fetchPocStakingInfoByAddr(String addr) async {
    try {
      var res = await apiRoot
          .evalJavascript('api.query.pocStaking.stakingInfoOf("$addr")');
      print("stakingInfoOf");
      print(res);
      if (res != null) {
        PocStakingInfoModel data = PocStakingInfoModel.fromJson(res);
        return data;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }


  Future<void> fetchPocMinersOf() async {
    String addr = store.account.currentAccount.address;

    if (addr != null && addr.isNotEmpty) {
      try {
        List res = await apiRoot
            .evalJavascript('api.query.pocStaking.minersOf("$addr")');
        if (res != null) {
          res = res.map((e) => e.toString()).toList();
          store.ipse.setpocMinersOf(res);
        } else {
          store.ipse.setpocMinersOf([]);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }


  Future<PocMiningHistoryModel> fetchPocMinersMiningHistoryList(
      String miner) async {
    PocMiningHistoryModel pocMiningHistoryModel;
    if (miner != null && miner.isNotEmpty) {
      try {
        Map res =
            await apiRoot.evalJavascript('api.query.poC.history("$miner")');
        if (res != null) {
          pocMiningHistoryModel = PocMiningHistoryModel.fromJson(res);
        } else {
          // pocMiningHistoryModel= PocMiningHistoryModel.fromJson();
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
    return pocMiningHistoryModel;
  }

  
  Future<List> fetchPocMyMiningHistoryList() async {
    String addr = store.account.currentAccount.address;
    List res;
    if (addr != null && addr.isNotEmpty) {
      try {
        res = await apiRoot
            .evalJavascript('api.query.poC.userRewardHistory("$addr")');
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
    return res;
  }


  Future<IpseMiningHistoryModel> fetchIpseMinersMiningHistoryList(
      String miner) async {
    IpseMiningHistoryModel ipseMiningHistoryModel;
    if (miner != null && miner.isNotEmpty) {
      try {
        Map res =
            await apiRoot.evalJavascript('api.query.ipse.history("$miner")');
        if (res != null) {
          ipseMiningHistoryModel = IpseMiningHistoryModel.fromJson(res);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
    return ipseMiningHistoryModel;
  }




  Future<void> fetchPocMinersList() async {
    String addr = store.account.currentAccount.address;

    if (addr != null && addr.isNotEmpty) {
      try {
        List res = await apiRoot.evalJavascript('ipse.fetchPocMinersList()');
        if (res != null) {
          res = res.map((e) => PocStakingInfoModel.fromJson(e)).toList();
          store.ipse.setPocMinersList(res);
        } else {
          store.ipse.setPocMinersList([]);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }


  Future<void> fetchPoclockList() async {
    String addr = store.account.currentAccount.address;

    if (addr != null && addr.isNotEmpty) {
      try {
        List res = await Future.wait([
          apiRoot.evalJavascript('api.query.pocStaking.locks("$addr")'),
          apiRoot.evalJavascript('api.rpc.chain.getHeader()'),
        ]);
        if (res[0] != null) {
          store.ipse.setPoclockList(res[0]);
        } else {
          store.ipse.setPoclockList([]);
        }
        if (res[1] != null) {
          store.ipse.setNewHeads(res[1]);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }


  Future<List> fetchIpseClaimRecord() async {
    try {
      String addr = store.account.currentAccount.address;

      if (addr != null && addr.isNotEmpty) {
        List res = await apiRoot
            .evalJavascript('ipse.fetchClaimList("$addr")');
        if (res != null) {
          return res;
        }
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }


  Future<int> fetchStakingMinBondAmount() async {
    try {
      int res =
          await apiRoot.evalJavascript('api.consts.staking.minBondAmount');
      if (res != null) {
        return res;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }

 
  Future<int> fetchIpseClaimStopTime() async {
    try {
      int res =
          await apiRoot.evalJavascript('api.query.exchange.rootDeadlineTime()');
      if (res != null) {
        return res;
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
    return null;
  }


  Future<void> fetchIpseOrderList() async {
    try {
      List res = await apiRoot.evalJavascript('ipse.fetchIpseOrderList()');
      if (res != null) {
        List<IpseOrderModel> list =
            res.map((e) => IpseOrderModel.fromJson(e)).toList();

       
        list.sort((a, b) => b.updateTs.compareTo(a.updateTs));
        store.ipse.setIpseListOrder(list);
      } else {
        store.ipse.setIpseListOrder([]);
      }
    } catch (e) {
      print(e);
      showErrorMsg(e.toString());
    }
  }

  
  Future<List<IpseOrderModel>> fetchIpseMinerOrderList() async {
    String addr = store.account.currentAccount.address;

    List<IpseOrderModel> data;
    if (addr != null && addr.isNotEmpty) {
      try {
        List res = await apiRoot
            .evalJavascript('ipse.fetchIpseMinerOrderList("$addr")');
        if (res != null) {
          data = res.map((e) => IpseOrderModel.fromJson(e)).toList();
          data.sort((a, b) => b.updateTs.compareTo(a.updateTs));
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
    return data;
  }

  
  Future<void> fetchIpseMinersList() async {
    String addr = store.account.currentAccount.address;

    if (addr != null && addr.isNotEmpty) {
      try {
        List res = await apiRoot.evalJavascript('ipse.fetchIpseMinersList()');
        if (res != null) {
          res = res.map((e) => IpseRegisterStatusModel.fromJson(e)).toList();
          store.ipse.setIpseMinersList(res);
        } else {
          store.ipse.setIpseMinersList([]);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }

  
  Future<void> fetchPocIsChillTime() async {
    String addr = store.account.currentAccount.address;
    if (addr != null && addr.isNotEmpty) {
      try {
        var res =
            await apiRoot.evalJavascript('api.query.pocStaking.isChillTime()');
        if (res != null) {
          store.ipse.setPocIsChillTime(res);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }

  
  Future<void> fetchPocChillTime() async {
    String addr = store.account.currentAccount.address;
    if (addr != null && addr.isNotEmpty) {
      try {
        var res =
            await apiRoot.evalJavascript('api.query.pocStaking.chillTime()');
        if (res != null) {
          print(res);
          store.ipse.setPocChillTime(res);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }

  
  Future<void> fetchGlobalData() async {
    String addr = store.account.currentAccount.address;
    if (addr != null && addr.isNotEmpty) {
      try {
        var res = await apiRoot.evalJavascript('ipse.fetchGlobalData()');
        if (res != null) {
          store.ipse.setPocGlobalData(res);
        }
      } catch (e) {
        print(e);
        showErrorMsg(e.toString());
      }
    }
  }

  
  void subBalanceChange() {
    String addr = store.account.currentAccount.address;
    String pubKey = store.account.currentAccount.pubKey;
    if (addr != null && addr.isNotEmpty) {
      apiRoot.evalJavascript(
        'ipse.subBalance("$addr","$pubKey")',
      );
    }
  }

  
  void subNewHeadsChange() {
    String addr = store.account.currentAccount.address;
    if (addr != null && addr.isNotEmpty) {
      apiRoot.evalJavascript('ipse.subNewHeads("$addr")');
    }
  }

  Future<dynamic> sendTx(
      BuildContext context, Map txInfo, List params, String notificationTitle,
      {String rawParam}) async {
    String param = rawParam != null ? rawParam : jsonEncode(params);
    try {
      var res = await apiRoot
          .evalJavascript('ipse.sendTx(${jsonEncode(txInfo)}, $param)');

      if (res != null) {
        if ((res as String).contains('Invalid Transaction: Payment')) {
          showErrorMsg(I18n.of(context).assets['amount.low']);
          return null;
        } else if ((res as String) == 'fail') {
          showErrorMsg(I18n.of(context).ipse['operateFailed']);
          return null;
        }
       
      }

      return res;
    } catch (e) {
      showErrorMsg(e.message);
      return null;
    }
  }

}
