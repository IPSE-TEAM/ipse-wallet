import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/council/types/electionData.dart';
import 'package:ipsewallet/store/council/types/electionsInfo.dart';

class ApiCouncil {
  ApiCouncil(this.apiRoot);

  final Api apiRoot;
  final store = globalAppStore;

  /// prime
  Future<void> queryPrime() async {
    String primes = await apiRoot.evalJavascript('api.query.council.prime()');
    store.council.setPrimes(primes);
  }

  /// Overview
  Future<void> fetchOverview() async {
    var electionsInfo = await apiRoot.evalJavascript('api.derive.elections.info()');
    List all = []; 
    if (electionsInfo != null) {
      ElectionsInfo info = ElectionsInfo.fromJson(electionsInfo);
      store.council.setElectionsInfo(info);

      var candidates = electionsInfo['candidates'] as List;
      var members = electionsInfo['members'] as List;
      var runnersUp = electionsInfo['runnersUp'] as List;

      [candidates, members, runnersUp].asMap().forEach((index, ele) {
        if (ele != null) {
          List<ElectionData> list = [];
          for(int i = 0; i < ele.length; i++) {
            var item = ele[i];
            ElectionData d = new ElectionData();
            d.address = item[0];
            d.accountName = item[0];
            d.balance = item[1].toString();
            list.add(d);
            all.add(item[0]);
          }
          if (index == 0) store.council.setCandidates(list);
          if (index == 1) store.council.setMembers(list);
          if (index == 2) store.council.setRunnersUp(list);
        }
      });
    }

    var allVotes = await apiRoot.evalJavascript('api.derive.council.votes()') as List;
    if (allVotes != null) {
      Map<String, List> list = {};
      for(int i = 0; i < allVotes.length; i++) {
        var item = allVotes[i];
        var voter = item[0] as String;
        var votes = item[1]['votes'] as List;
        var stake = item[1]['stake'];

        votes.forEach((vote) {
          if (list.keys.contains(vote)) {
            list[vote].add([voter, stake]);
          } else {
            list[vote] = [[voter, stake]];
          }
        });
        all.add(voter);
      }
      store.council.setAllVotes(list);
    }
    
    if (all.isEmpty) return;
    await apiRoot.account.fetchAddressIndex(all);
    await apiRoot.account.getAddressIcons(all);
  }


  Future<void> addCheckedElection(ElectionData item) async {
    List<ElectionData> checkdElections = List<ElectionData>.generate(
      store.council.checkdElection.length, (i) => store.council.checkdElection[i]);
    if (checkdElections.any((ele) => ele.address == item.address)) {
      canclCheckedElection(item);
    } else {
      checkdElections.add(item);
      store.council.setCheckdElection(checkdElections);
    }
  }

  Future<void> canclCheckedElection(ElectionData item) async {
    List<ElectionData> checkdElections = store.council.checkdElection;
    for(int i = 0; i < checkdElections.length; i++) {
      if (checkdElections[i].address == item.address) {
        checkdElections.removeAt(i);
      }
    }
    store.council.setCheckdElection(checkdElections);
  }


  Future<void> clearCheckElection() async {
    store.council.setCheckdElection([]);
  }

  /// motions
  Future<void> fetchMotions() async {
    var res = await apiRoot.evalJavascript('api.derive.council.proposals()');
    print('========council.proposals========');
    print(res);
    print('========council.proposals========');
  }

  ///  tx
  Future<Map> getModLocation() async {
    var res = await apiRoot.evalJavascript('council.modLocation(api)') as Map;
    return res;
  }
}                                                                     
