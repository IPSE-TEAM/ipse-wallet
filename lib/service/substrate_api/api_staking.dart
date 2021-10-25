import 'package:ipsewallet/service/request_service.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/result_data.dart';

class ApiStaking {
  ApiStaking(this.apiRoot);

  final Api apiRoot;
  final store = globalAppStore;

  Future<void> fetchAccountStaking() async {
    final String pubKey = store.account.currentAccountPubKey;
    if (pubKey != null && pubKey.isNotEmpty) {
      queryOwnStashInfo(pubKey);
    }
  }

  Future<List> fetchAccountRewardsEraOptions() async {
    final List res =
        await apiRoot.evalJavascript('staking.getAccountRewardsEraOptions()');
    return res;
  }

  // this query takes extremely long time
  Future<void> fetchAccountRewards(String pubKey, int eras) async {
    if (store.staking.ownStashInfo != null &&
        store.staking.ownStashInfo.stakingLedger != null) {
      BigInt bonded = BigInt.parse(store.staking.ownStashInfo.stakingLedger['active'].toString());
      List unlocking = store.staking.ownStashInfo.stakingLedger['unlocking'];
      if (pubKey != null && (bonded > BigInt.zero || unlocking.length > 0)) {
        String address = store.staking.ownStashInfo.stashId;
        print('fetching staking rewards...');
        Map res = await apiRoot.evalJavascript(
            'staking.loadAccountRewardsData("$address", $eras)');
        store.staking.setRewards(pubKey, res);
        return;
      }
    }
    store.staking.setRewards(pubKey, {});
  }

  Future<Map> fetchStakingOverview() async {
    List res = await Future.wait([
      apiRoot.evalJavascript('staking.fetchStakingOverview()'),
      apiRoot.evalJavascript('api.derive.staking.currentPoints()'),
    ]);
    if (res[0] == null || res[1] == null) return null;
    Map overview = res[0];
    overview['eraPoints'] = res[1];
    store.staking.setOverview(overview);

    fetchElectedInfo();
    // phala airdrop for kusama
//    if (store.settings.endpoint.info == network_name_kusama) {
//      fetchPhalaAirdropList();
//    }

    List validatorAddressList = List.of(overview['validators']);
    validatorAddressList.addAll(overview['waiting']);
    await apiRoot.account.fetchAddressIndex(validatorAddressList);
    apiRoot.account.getAddressIcons(validatorAddressList);
    return overview;
  }

  Future<List> updateStaking(int page) async {
    store.staking.setTxsLoading(true);

    ResultData res = await RequestService.getStakingOperate(
        store.account.currentAddress,
        store.settings.networkName.toLowerCase(),
        page);
    if (page == 0) {
      store.staking.clearTxs();
    }
    if (res.code != 111) {
      await store.staking
          .addTxs((res.data["data"] as List), shouldCache: page == 0);

      store.staking.setTxsLoading(false);

      return res.data["data"];
    }
    return null;
  }

  Future<List> updateStakingRewards() async {
    final address =
        store.staking.ownStashInfo?.stashId ?? store.account.currentAddress;
    // final res = await apiRoot.subScanApi.fetchRewardTxsAsync(
    //   page: 0,
    //   sender: address,
    //   network: store.settings.networkName.toLowerCase(),
    // );

    ResultData res = await RequestService.getStakingRewards(
        address, store.settings.networkName.toLowerCase(), 0);
    if (res.code != 111) {
      await store.staking
          .addTxsRewards((res.data["data"] as List), shouldCache: true);
      return (res.data["data"] as List);
    } else {
      return null;
    }
  }

  // this query takes a long time
  Future<void> fetchElectedInfo() async {
    // fetch all validators details
    var res = await apiRoot.evalJavascript('api.derive.staking.electedInfo()');
    store.staking.setValidatorsInfo(res);
  }

  Future<Map> queryValidatorRewards(String accountId) async {
    int timestamp = DateTime.now().second;
    Map cached = store.staking.rewardsChartDataCache[accountId];
    if (cached != null && cached['timestamp'] > timestamp - 1800) {
      return cached;
    }
    print('fetching rewards chart data');
    Map data = await apiRoot
        .evalJavascript('staking.loadValidatorRewardsData(api, "$accountId")');
    if (data != null) {
      // format rewards data & set cache
      Map chartData = Fmt.formatRewardsChartData(data);
      chartData['timestamp'] = timestamp;
      store.staking.setRewardsChartData(accountId, chartData);
    }
    return data;
  }

  Future<Map> queryOwnStashInfo(String pubKey) async {
    final accountId = store.account.currentAddress;
    Map data =
        await apiRoot.evalJavascript('staking.getOwnStashInfo("$accountId")');
    store.staking.setOwnStashInfo(pubKey, data);

    final List<String> addressesNeedIcons =
        store.staking.ownStashInfo?.nominating != null
            ? store.staking.ownStashInfo.nominating.toList()
            : [];
    final List<String> addressesNeedDecode = [];
    if (store.staking.ownStashInfo?.stashId != null) {
      addressesNeedIcons.add(store.staking.ownStashInfo.stashId);
      addressesNeedDecode.add(store.staking.ownStashInfo.stashId);
    }
    if (store.staking.ownStashInfo?.controllerId != null) {
      addressesNeedIcons.add(store.staking.ownStashInfo.controllerId);
      addressesNeedDecode.add(store.staking.ownStashInfo.controllerId);
    }

    await apiRoot.account.getAddressIcons(addressesNeedIcons);

    // get stash&controller's pubKey
    apiRoot.account.decodeAddress(addressesNeedIcons);

    return data;
  }
}
