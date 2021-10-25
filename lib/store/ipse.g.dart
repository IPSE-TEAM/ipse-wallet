// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ipse.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$IpseStore on _IpseStoreBase, Store {
  Computed<String> _$ipComputed;

  @override
  String get ip => (_$ipComputed ??=
          Computed<String>(() => super.ip, name: '_IpseStoreBase.ip'))
      .value;
  Computed<String> _$urlComputed;

  @override
  String get url => (_$urlComputed ??=
          Computed<String>(() => super.url, name: '_IpseStoreBase.url'))
      .value;

  final _$pendingTaskAtom = Atom(name: '_IpseStoreBase.pendingTask');

  @override
  int get pendingTask {
    _$pendingTaskAtom.reportRead();
    return super.pendingTask;
  }

  @override
  set pendingTask(int value) {
    _$pendingTaskAtom.reportWrite(value, super.pendingTask, () {
      super.pendingTask = value;
    });
  }

  final _$ipseRegisterStatusAtom =
      Atom(name: '_IpseStoreBase.ipseRegisterStatus');

  @override
  IpseRegisterStatusModel get ipseRegisterStatus {
    _$ipseRegisterStatusAtom.reportRead();
    return super.ipseRegisterStatus;
  }

  @override
  set ipseRegisterStatus(IpseRegisterStatusModel value) {
    _$ipseRegisterStatusAtom.reportWrite(value, super.ipseRegisterStatus, () {
      super.ipseRegisterStatus = value;
    });
  }

  final _$pocRegisterStatusAtom =
      Atom(name: '_IpseStoreBase.pocRegisterStatus');

  @override
  PocRegisterStatusModel get pocRegisterStatus {
    _$pocRegisterStatusAtom.reportRead();
    return super.pocRegisterStatus;
  }

  @override
  set pocRegisterStatus(PocRegisterStatusModel value) {
    _$pocRegisterStatusAtom.reportWrite(value, super.pocRegisterStatus, () {
      super.pocRegisterStatus = value;
    });
  }

  final _$newHeadsAtom = Atom(name: '_IpseStoreBase.newHeads');

  @override
  NewHeadsModel get newHeads {
    _$newHeadsAtom.reportRead();
    return super.newHeads;
  }

  @override
  set newHeads(NewHeadsModel value) {
    _$newHeadsAtom.reportWrite(value, super.newHeads, () {
      super.newHeads = value;
    });
  }

  final _$pocIsChillTimeAtom = Atom(name: '_IpseStoreBase.pocIsChillTime');

  @override
  bool get pocIsChillTime {
    _$pocIsChillTimeAtom.reportRead();
    return super.pocIsChillTime;
  }

  @override
  set pocIsChillTime(bool value) {
    _$pocIsChillTimeAtom.reportWrite(value, super.pocIsChillTime, () {
      super.pocIsChillTime = value;
    });
  }

  final _$pocChillTimeAtom = Atom(name: '_IpseStoreBase.pocChillTime');

  @override
  ObservableList<dynamic> get pocChillTime {
    _$pocChillTimeAtom.reportRead();
    return super.pocChillTime;
  }

  @override
  set pocChillTime(ObservableList<dynamic> value) {
    _$pocChillTimeAtom.reportWrite(value, super.pocChillTime, () {
      super.pocChillTime = value;
    });
  }

  final _$pocGlobalDataAtom = Atom(name: '_IpseStoreBase.pocGlobalData');

  @override
  PocGlobalDataModel get pocGlobalData {
    _$pocGlobalDataAtom.reportRead();
    return super.pocGlobalData;
  }

  @override
  set pocGlobalData(PocGlobalDataModel value) {
    _$pocGlobalDataAtom.reportWrite(value, super.pocGlobalData, () {
      super.pocGlobalData = value;
    });
  }

  final _$pocStakingInfoAtom = Atom(name: '_IpseStoreBase.pocStakingInfo');

  @override
  PocStakingInfoModel get pocStakingInfo {
    _$pocStakingInfoAtom.reportRead();
    return super.pocStakingInfo;
  }

  @override
  set pocStakingInfo(PocStakingInfoModel value) {
    _$pocStakingInfoAtom.reportWrite(value, super.pocStakingInfo, () {
      super.pocStakingInfo = value;
    });
  }

  final _$pocMinersOfAtom = Atom(name: '_IpseStoreBase.pocMinersOf');

  @override
  ObservableList<String> get pocMinersOf {
    _$pocMinersOfAtom.reportRead();
    return super.pocMinersOf;
  }

  @override
  set pocMinersOf(ObservableList<String> value) {
    _$pocMinersOfAtom.reportWrite(value, super.pocMinersOf, () {
      super.pocMinersOf = value;
    });
  }

  final _$pocMinersListAtom = Atom(name: '_IpseStoreBase.pocMinersList');

  @override
  ObservableList<PocStakingInfoModel> get pocMinersList {
    _$pocMinersListAtom.reportRead();
    return super.pocMinersList;
  }

  @override
  set pocMinersList(ObservableList<PocStakingInfoModel> value) {
    _$pocMinersListAtom.reportWrite(value, super.pocMinersList, () {
      super.pocMinersList = value;
    });
  }

  final _$poclockListAtom = Atom(name: '_IpseStoreBase.poclockList');

  @override
  ObservableList<dynamic> get poclockList {
    _$poclockListAtom.reportRead();
    return super.poclockList;
  }

  @override
  set poclockList(ObservableList<dynamic> value) {
    _$poclockListAtom.reportWrite(value, super.poclockList, () {
      super.poclockList = value;
    });
  }

  final _$ipseMinersListAtom = Atom(name: '_IpseStoreBase.ipseMinersList');

  @override
  ObservableList<IpseRegisterStatusModel> get ipseMinersList {
    _$ipseMinersListAtom.reportRead();
    return super.ipseMinersList;
  }

  @override
  set ipseMinersList(ObservableList<IpseRegisterStatusModel> value) {
    _$ipseMinersListAtom.reportWrite(value, super.ipseMinersList, () {
      super.ipseMinersList = value;
    });
  }

  final _$ipseListOrderAtom = Atom(name: '_IpseStoreBase.ipseListOrder');

  @override
  ObservableList<IpseOrderModel> get ipseListOrder {
    _$ipseListOrderAtom.reportRead();
    return super.ipseListOrder;
  }

  @override
  set ipseListOrder(ObservableList<IpseOrderModel> value) {
    _$ipseListOrderAtom.reportWrite(value, super.ipseListOrder, () {
      super.ipseListOrder = value;
    });
  }

  final _$countAtom = Atom(name: '_IpseStoreBase.count');

  @override
  int get count {
    _$countAtom.reportRead();
    return super.count;
  }

  @override
  set count(int value) {
    _$countAtom.reportWrite(value, super.count, () {
      super.count = value;
    });
  }

  final _$searchResultsAtom = Atom(name: '_IpseStoreBase.searchResults');

  @override
  ObservableList<Resource> get searchResults {
    _$searchResultsAtom.reportRead();
    return super.searchResults;
  }

  @override
  set searchResults(ObservableList<Resource> value) {
    _$searchResultsAtom.reportWrite(value, super.searchResults, () {
      super.searchResults = value;
    });
  }

  final _$_ipAtom = Atom(name: '_IpseStoreBase._ip');

  @override
  String get _ip {
    _$_ipAtom.reportRead();
    return super._ip;
  }

  @override
  set _ip(String value) {
    _$_ipAtom.reportWrite(value, super._ip, () {
      super._ip = value;
    });
  }

  final _$_urlAtom = Atom(name: '_IpseStoreBase._url');

  @override
  String get _url {
    _$_urlAtom.reportRead();
    return super._url;
  }

  @override
  set _url(String value) {
    _$_urlAtom.reportWrite(value, super._url, () {
      super._url = value;
    });
  }

  final _$_getPocRegisterStatusAsyncAction =
      AsyncAction('_IpseStoreBase._getPocRegisterStatus');

  @override
  Future<void> _getPocRegisterStatus() {
    return _$_getPocRegisterStatusAsyncAction
        .run(() => super._getPocRegisterStatus());
  }

  final _$getsearchResultsAsyncAction =
      AsyncAction('_IpseStoreBase.getsearchResults');

  @override
  Future<void> getsearchResults(SearchParams params) {
    return _$getsearchResultsAsyncAction
        .run(() => super.getsearchResults(params));
  }

  final _$checkGatewayAsyncAction = AsyncAction('_IpseStoreBase.checkGateway');

  @override
  Future<void> checkGateway() {
    return _$checkGatewayAsyncAction.run(() => super.checkGateway());
  }

  final _$_getSetingIpAsyncAction = AsyncAction('_IpseStoreBase._getSetingIp');

  @override
  Future<void> _getSetingIp() {
    return _$_getSetingIpAsyncAction.run(() => super._getSetingIp());
  }

  final _$initAsyncAction = AsyncAction('_IpseStoreBase.init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$_IpseStoreBaseActionController =
      ActionController(name: '_IpseStoreBase');

  @override
  void setPendingTask(int n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setPendingTask');
    try {
      return super.setPendingTask(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIpseRegisterStatus(IpseRegisterStatusModel val) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setIpseRegisterStatus');
    try {
      return super.setIpseRegisterStatus(val);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPocRegisterStatus(PocRegisterStatusModel val) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setPocRegisterStatus');
    try {
      return super.setPocRegisterStatus(val);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNewHeads(Map<dynamic, dynamic> n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setNewHeads');
    try {
      return super.setNewHeads(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPocIsChillTime(bool n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setPocIsChillTime');
    try {
      return super.setPocIsChillTime(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPocChillTime(List<dynamic> n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setPocChillTime');
    try {
      return super.setPocChillTime(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPocGlobalData(List<dynamic> n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setPocGlobalData');
    try {
      return super.setPocGlobalData(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPocStakingInfo(PocStakingInfoModel n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setPocStakingInfo');
    try {
      return super.setPocStakingInfo(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setpocMinersOf(List<String> n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setpocMinersOf');
    try {
      return super.setpocMinersOf(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPocMinersList(List<PocStakingInfoModel> n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setPocMinersList');
    try {
      return super.setPocMinersList(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPoclockList(List<dynamic> n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setPoclockList');
    try {
      return super.setPoclockList(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIpseMinersList(List<IpseRegisterStatusModel> n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setIpseMinersList');
    try {
      return super.setIpseMinersList(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIpseListOrder(List<IpseOrderModel> n) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setIpseListOrder');
    try {
      return super.setIpseListOrder(n);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setip(dynamic ip) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setip');
    try {
      return super.setip(ip);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUrl(dynamic url) {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.setUrl');
    try {
      return super.setUrl(url);
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearState() {
    final _$actionInfo = _$_IpseStoreBaseActionController.startAction(
        name: '_IpseStoreBase.clearState');
    try {
      return super.clearState();
    } finally {
      _$_IpseStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pendingTask: ${pendingTask},
ipseRegisterStatus: ${ipseRegisterStatus},
pocRegisterStatus: ${pocRegisterStatus},
newHeads: ${newHeads},
pocIsChillTime: ${pocIsChillTime},
pocChillTime: ${pocChillTime},
pocGlobalData: ${pocGlobalData},
pocStakingInfo: ${pocStakingInfo},
pocMinersOf: ${pocMinersOf},
pocMinersList: ${pocMinersList},
poclockList: ${poclockList},
ipseMinersList: ${ipseMinersList},
ipseListOrder: ${ipseListOrder},
count: ${count},
searchResults: ${searchResults},
ip: ${ip},
url: ${url}
    ''';
  }
}
