import 'dart:async';

import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/ipse_order_model.dart';
import 'package:ipsewallet/model/new_heads_model.dart';
import 'package:ipsewallet/model/poc_global_data_model.dart';
import 'package:ipsewallet/model/resource.dart';
import 'package:ipsewallet/model/ipse_register_status_model.dart';
import 'package:ipsewallet/model/poc_staking_info_model.dart';
import 'package:ipsewallet/model/search_params.dart';
import 'package:ipsewallet/service/request_service.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/utils/result_data.dart';
import 'package:mobx/mobx.dart';
import 'package:ipsewallet/model/poc_register_status_model.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/local_storage.dart';
part 'ipse.g.dart';

class IpseStore = _IpseStoreBase with _$IpseStore;

abstract class _IpseStoreBase with Store {
  _IpseStoreBase(this.rootStore);
  final AppStore rootStore;

  @observable
  int pendingTask = 0;

  @action
  void setPendingTask(int n) {
    pendingTask = n;
  }


  @observable
  IpseRegisterStatusModel ipseRegisterStatus;

  @action
  void setIpseRegisterStatus(IpseRegisterStatusModel val) {
    ipseRegisterStatus = val;
  }

  @observable
  PocRegisterStatusModel pocRegisterStatus;

  @action
  void setPocRegisterStatus(PocRegisterStatusModel val) {
    pocRegisterStatus = val;
    LocalStorage.setPocRegisterStatus(val);
  }

  @action
  Future<void> _getPocRegisterStatus() async {
    PocRegisterStatusModel res = await LocalStorage.getPocRegisterStatus();
    if (res != null) {
      pocRegisterStatus = res;
    }
  }


  @observable
  NewHeadsModel newHeads;


  @action
  void setNewHeads(Map n) {
    newHeads = n != null ? NewHeadsModel.fromJson(n) : null;
  }


  @observable
  bool pocIsChillTime;

  @action
  void setPocIsChillTime(bool n) {
    pocIsChillTime = n;
  }

  
  @observable
  ObservableList pocChillTime;


  @action
  void setPocChillTime(List n) {
    pocChillTime = n == null ? n : ObservableList.of(n);
  }

  
  @observable
  PocGlobalDataModel pocGlobalData;

  
  @action
  void setPocGlobalData(List n) {
    pocGlobalData = PocGlobalDataModel.fromList(n) ;
  }

  
  
  

  
  
  
  
  

  @observable
  PocStakingInfoModel pocStakingInfo;

  
  @action
  void setPocStakingInfo(PocStakingInfoModel n) {
    pocStakingInfo = n;
  }

  
  @observable
  ObservableList<String> pocMinersOf;

  
  @action
  void setpocMinersOf(List<String> n) {
    pocMinersOf = n == null ? n : ObservableList.of(n);
  }

  
  @observable
  ObservableList<PocStakingInfoModel> pocMinersList;

  
  @action
  void setPocMinersList(List<PocStakingInfoModel> n) {
    pocMinersList = n == null ? n : ObservableList.of(n);
  }

  
  @observable
  ObservableList poclockList;

  
  @action
  void setPoclockList(List n) {
    poclockList = n == null ? n : ObservableList.of(n);
  }

  
  @observable
  ObservableList<IpseRegisterStatusModel> ipseMinersList;

  
  @action
  void setIpseMinersList(List<IpseRegisterStatusModel> n) {
    ipseMinersList = n == null ? n : ObservableList.of(n);
  }

  
  @observable
  ObservableList<IpseOrderModel> ipseListOrder;

  
  @action
  void setIpseListOrder(List<IpseOrderModel> n) {
    ipseListOrder = n == null ? n : ObservableList.of(n);
  }

  @observable
  int count;

  @observable
  ObservableList<Resource> searchResults;

  @action
  Future<void> getsearchResults(SearchParams params) async {
    List<Resource> searhResultList;
    if (params.page == 1) {
      searhResultList = [];
      searchResults = null;
    } else {
      searhResultList = searchResults?.toList()??[];
    }
    ResultData res = await RequestService.searchData(params);
    if (res.code != 111 && res.data['Status'] == 200) {
      List listData = res.data['Res'] ?? [];
      print(listData);
      count = res.data["Count"];
      List<Resource> searchResultsData =
          listData.map((v) => Resource.fromJson(v)).toList();

      searhResultList.addAll(searchResultsData);
      searchResults = ObservableList.of(searhResultList);
    } else {
      showErrorMsg(res.data);
    }
  }

  @observable
  String _ip;

  @computed
  String get ip => _ip;

  @observable
  String _url = "${Config.urlList[0]}/ipfs/";

  @computed
  String get url => _url; 

  int _index = 0;
  String _checkedUrl;

  
  @action
  void setip(ip) {
    _ip = ip;
    String url;
    if (_ip != null && _ip.isNotEmpty) {
      url = "http://$_ip:8080/ipfs/";
    } else if (_checkedUrl == null) {
      url = "${Config.urlList[0]}/ipfs/";
      checkGateway();
    } else {
      url = "$_checkedUrl/ipfs/";
      _checkedUrl = null;
    }
    setUrl(url);
  }

  @action
  void setUrl(url) {
    _url = url;
  }

  @action
  Future<void> checkGateway() async {
    if (_index >= Config.urlList.length) {
      return;
    }
    String url = Config.urlList[_index];
    String now=DateTime.now().millisecondsSinceEpoch.toString();
    ResultData res = await RequestService.checkGateway(url + Config.testHash+"?now=$now");
    if (res.code != 111 && res.data == "Hello from IPFS Gateway Checker\n") {
      _checkedUrl = url;
      setip("");
    } else {
      _index += 1;
      checkGateway();
    }
  }

  @action
  
  Future<void> _getSetingIp() async {
    String ipStr = await rootStore.localStorage.getObject("ip");
    if (ipStr != null) {
      setip(ipStr);
    }else{
       setip("");
    }
  }

  @action
  void clearState() {
    pocRegisterStatus = null;
    pocStakingInfo = null;
    pocMinersOf = null;
    poclockList = null;
    ipseRegisterStatus = null;
  }

  @action
  Future<void> init() async {
    await _getSetingIp();
    await _getPocRegisterStatus();
  }
}
