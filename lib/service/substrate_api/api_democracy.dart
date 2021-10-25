import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/democracy/types/democracyInfo.dart';
import 'package:ipsewallet/store/democracy/types/externalData.dart';
import 'package:ipsewallet/store/democracy/types/proposalData.dart';
import 'package:ipsewallet/store/democracy/types/referendumData.dart';

class ApiDemocracy {
  ApiDemocracy(this.apiRoot);

  final Api apiRoot;
  final store = globalAppStore;

  /// Summary
  Future<void> fetchSummary() async {
   var publicPropCount = await apiRoot.evalJavascript('api.query.democracy.publicPropCount()');
    var referendumCount = await apiRoot.evalJavascript('api.query.democracy.referendumCount()');
    var launchPeriod =await apiRoot.evalJavascript('democ.fetchLaunchPeriod()');
    try {
      DemocracyInfo info = DemocracyInfo.fromJson({
        'publicPropCount': publicPropCount,
        'referendumCount': referendumCount,
        'launchPeriod': launchPeriod
      });
      store.democ.setDemocracyInfo(info);
    } catch (e) { print(e.toString()); }

  }

  /// referenda : use long time
  Future<void> fetchReferendums() async {
    Map res = await apiRoot.evalJavascript(
      'democ.fetchReferendums("${store.account.currentAddress}")');
    List all = [];
    if (res != null) {
      List list = res['referendums'];
      List<ReferendumData> newListData = [];
      list.asMap().forEach((k, v) {
        v['detail'] = res['details'][k];
        ReferendumData r = ReferendumData.fromJson(v);
        newListData.add(r);
      });
      store.democ.setReferendums(newListData);
      newListData.forEach((item) { 
        item.allAye.forEach((aye) {
          all.add(aye.accountId);
        });
        item.allNay.forEach((nay) {
          all.add(nay.accountId);
        });
      });
    }
    if (all.isEmpty) return;
    await apiRoot.account.fetchAddressIndex(all);
    await apiRoot.account.getAddressIcons(all);
  }

  /// Proposals 
  Future<void> fetchProposals() async {
    Map res = await apiRoot.evalJavascript('democ.fetchProposals()');
    List all = [];
    if (res != null) {
      List list = res['proposals'];
      List<ProposalData> newListData = [];
      list.asMap().forEach((k, v) {
        v['detail'] = res['details'][k];
        ProposalData r = ProposalData.fromJson(v);
        newListData.add(r);
        all.addAll(v['seconds']);
        all.add(v['proposer']);
      });
      store.democ.setProposals(newListData);
    }
    if (all.isEmpty) return;
    await apiRoot.account.fetchAddressIndex(all);
    await apiRoot.account.getAddressIcons(all);
  }

  /// Dispatch Queue 
  Future<void> fetchDispatchQueue() async {
    var res = await apiRoot.evalJavascript('api.derive.democracy.dispatchQueue()');
    print('++++++++DispatchQueue+++++++++++');
    print(res);
    print('+++++++++++++++++++');
  }

  /// Externals
  Future<void> fetchExternals() async {
    var res = await apiRoot.evalJavascript('api.derive.democracy.nextExternal()');
    if (res != null) {
      ExternalData newExternal  = ExternalData.fromJson(res);
      store.democ.setNextExternal(newExternal);
    }
  }

  /// secondMetaArgsLength
  Future<int> secondMetaArgsLength() async {
    var res = await apiRoot.evalJavascript('democ.secondMetaArgsLength(api)') as int;
    return res;
  }

  /// isCurrentVote
  Future<bool> isCurrentVote() async {
    var res = await apiRoot.evalJavascript('democ.isCurrentVote(api)') as bool;
    return res;
  }

  /// enact
  Future<num> enact() async {
    var res = await apiRoot.evalJavascript('democ.enact(api)') as num;
    return res;
  }
}                                                                     
