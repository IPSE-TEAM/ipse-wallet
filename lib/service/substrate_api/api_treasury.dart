import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/treasury/types/tipData.dart';

class ApiTreasury {
  ApiTreasury(this.apiRoot);

  final Api apiRoot;
  final store = globalAppStore;

  /// members
  Future<void> queryMembers() async {
    var members = await apiRoot.evalJavascript('api.query.council.members()');
    store.treasury.setMembers(members);
  }

  /// prime
  Future<void> queryPrime() async {
    var proposals = await apiRoot.evalJavascript('api.derive.treasury.proposals()');
    store.treasury.setProposals(proposals);
  }

  /// Overview
  Future<void> fetchOverview() async {
    var res = await apiRoot.evalJavascript('treasury.fetchOverview(api)');
    store.treasury.setSummary(res);
  }

  /// tips
  Future<void> queryTips() async {
    var tips = await apiRoot.evalJavascript('treasury.fetchTips(api)') as List;
    List<TipData> res = [];
    List all = [];
    for (int i = 0; i < tips.length; i++) {
      var item = tips[i];
      res.add(TipData.fromJson(item));
      if (item['who'] != null) {
        all.add(item['who']);
      }
      if (item['finder'] != null && item['finder'][0] != null) {
        all.add(item['finder'][0]);
      }
    }
    store.treasury.setTips(res);
    if (all.isEmpty) return;
    await apiRoot.account.fetchAddressIndex(all);
    await apiRoot.account.getAddressIcons(all);
  }

  // bondPercentage && proposalBondMinimum
  Future<Map> queryBondInfo() async {
    var res = await apiRoot.evalJavascript('treasury.queryBondInfo(api)') as Map;
    return res;
  }
}                                                                     
