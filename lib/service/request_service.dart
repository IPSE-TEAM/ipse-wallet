import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/model/search_params.dart';
import 'package:ipsewallet/utils/http_manager.dart';
import 'package:ipsewallet/utils/result_data.dart';

const int tx_list_page_size = 20;

class RequestService {
  static Future getNewVersionData() async {
    return await HttpManager.request(
      '/app/ipse-version.json',
      isShowError: false,
    );
  }

  static Future searchData(SearchParams params) async {
    String word = params.searchMatch;
    if (RegExp(r'^Qm[0-9a-zA-Z]{44}$').hasMatch(word)) {
      word = "_id:$word";
    }
    return await HttpManager.request(
        "/v3/esoper?search_match=$word&category=${params.category}&page=${params.page}&size=${params.size}");
  }


  static Future addLabelToMiner(
      String fileName,
      String url,
      String address,
      String hash,
      String label,
      String category,
      String describe,
      int days) async {
    return await HttpManager.request(
      "$url/api/v0/order/$address/$hash",
      method: "POST",
      params: {
        "name": fileName,
        "label": label,
        "category": category,
        "describe": describe,
        "days": days,
      },
      useBaseUrl: false,
    );
  }

  static Future getTokenTransactionTxs(
      String address, String network, int page, int size) async {
    if (!Config.supportNetworkList.contains(network))
      return ResultData("", 111);
    return await HttpManager.request(
        'https://scan.ipse.io/api/v1/balances/transfer?filter[address]=$address',
        method: 'GET',
        useBaseUrl: false);
  }


  static Future getStakingOperate(String address, String network, int page,
      {int size = tx_list_page_size}) async {
    if (!Config.supportNetworkList.contains(network))
      return ResultData("", 111);
    return await HttpManager.request(
        'https://scan.ipse.io/api/v1/extrinsic?filter[address]=$address&filter[search_index]=6,7,8,10,11,12,19&page[size]=$size',
        method: 'GET',
        useBaseUrl: false);
  }

  
  static Future getStakingRewards(String address, String network, int page,
      {int size = tx_list_page_size}) async {
    if (!Config.supportNetworkList.contains(network))
      return ResultData("", 111);
    return await HttpManager.request(
        'https://scan.ipse.io/api/v1/event?filter[address]=$address&filter[search_index]=39&page[size]=$size',
        method: 'GET',
        useBaseUrl: false);
  }

  static Future checkGateway(String url) async {
    return await HttpManager.request(url,
        useBaseUrl: false, isShowError: false);
  }
}
