import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/service/substrate_api/api_account.dart';
import 'package:ipsewallet/service/substrate_api/api_assets.dart';
import 'package:ipsewallet/service/substrate_api/api_gov.dart';
import 'package:ipsewallet/service/substrate_api/api_staking.dart';
import 'package:ipsewallet/service/substrate_api/api_ipse.dart';
import 'package:ipsewallet/service/substrate_api/types/genExternalLinksParams.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/local_storage.dart';

Api webApi;

class Api {
  Api(this.context, this.store);

  final BuildContext context;
  final AppStore store;
  final jsStorage = GetStorage();
  final configStorage = GetStorage('configuration');

  ApiIpse ipse;
  ApiAccount account;
  ApiAssets assets;
  ApiStaking staking;
  ApiGovernance gov;


  Map<String, Function> _msgHandlers = {};
  Map<String, Completer> _msgCompleters = {};
  FlutterWebviewPlugin _web;
  int _evalJavascriptUID = 0;

  /// preload js code for opening dApps
  String asExtensionJSCode;

  Future<void> close() async {
    await _web.close();
  }

 
  ///balanceList is[ freeBalance , reservedBalance]
  _setSubBalance(Map balanceData) {
    print('balance changed');
    // store.assets.setAccountBalances(store.account.currentAccount.pubKey,
    store.assets.setAccountBalances(balanceData['pubKey'],
        Map.of({store.settings.networkState.tokenSymbol??Config.tokenSymbol: balanceData}));
  }


  _setSubNewHeads(Map lastHeader) {
    store.ipse.setNewHeads(lastHeader);
  }


  _setDisconnected(bool disconnected) {
    store.settings.setNetworkLoading(disconnected);
  }

  void init() {
    ipse = ApiIpse(this);
    account = ApiAccount(this);
    assets = ApiAssets(this);
    staking = ApiStaking(this);
    gov = ApiGovernance(this);
 
    launchWebview();
  }


  Future<String> _getTypes() async {
    String types = await LocalStorage.getCustomTypes();
    if (types != null) {
      try {
        jsonDecode(types);
      } catch (e) {
        print(e);
        return null;
      }
    }
    return types;
  }

  Future<void> launchWebview() async {
    
    _msgHandlers['txStatusChange'] = store.account.setTxStatus;
    _msgHandlers['balanceChange'] = _setSubBalance;
    _msgHandlers['newHeadsChange'] = _setSubNewHeads;
    _msgHandlers['disconnected'] = _setDisconnected;

    _evalJavascriptUID = 0;
    _msgCompleters = {};

    if (_web != null) {
      _web.reload();
      return;
    }
    _web = FlutterWebviewPlugin();

    _web.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.finishLoad) {
       
        DefaultAssetBundle.of(context)
            .loadString('lib/polkadot_js_service/dist/main.js')
            .then((String js) async {
          // inject js file to webview
          _web.evalJavascript(js);

          // load keyPairs from local data
          await account.initAccounts();
          // connect remote node
          String customTypes = await _getTypes();
          connectNode(newTypes: customTypes);
        });
      }
    });

    _web.launch(
      'about:blank',
      javascriptChannels: [
        JavascriptChannel(
            name: 'IpseWallet',
            onMessageReceived: (JavascriptMessage message) {
             
              if(message.message.contains("newHeadsChange")==false){
                print('received msg: ${message.message}');
              }
              compute(jsonDecode, message.message).then((msg) {
                final msg = jsonDecode(message.message);
                final String path = msg['path'];
                if (_msgCompleters[path] != null) {
                  Completer handler = _msgCompleters[path];
                  handler.complete(msg['data']);
                  if (path.contains('uid=')) {
                    _msgCompleters.remove(path);
                  }
                }
                if (_msgHandlers[path] != null) {
                  Function handler = _msgHandlers[path];
                  handler(msg['data']);
                }
              });
            }),
      ].toSet(),
      ignoreSSLErrors: true,
//        withLocalUrl: true,
//        localUrlScope: 'lib/polkadot_js_service/dist/',
      hidden: true,
    );
  }

  int _getEvalJavascriptUID() {
    return _evalJavascriptUID++;
  }

  Future<dynamic> evalJavascript(
    String code, {
    bool wrapPromise = true,
    bool allowRepeat = false,
  }) async {
    // check if there's a same request loading
    if (!allowRepeat) {
      for (String i in _msgCompleters.keys) {
        String call = code.split('(')[0];
        if (i.contains(call)) {
          print('request $call loading');
         
          return _msgCompleters[i].future;
        }
      }
    }

    if (!wrapPromise) {
      String res = await _web.evalJavascript(code);
      return res;
    }

    Completer c = new Completer();

    String method = 'uid=${_getEvalJavascriptUID()};${code.split('(')[0]}';
    _msgCompleters[method] = c;

    String script = '$code.then(function(res) {'
        '  IpseWallet.postMessage(JSON.stringify({ path: "$method", data: res }));'
        '}).catch(function(err) {'
        '  IpseWallet.postMessage(JSON.stringify({ path: "log", data: err.message }));'
        '})';
    _web.evalJavascript(script);

    return c.future;
  }

  Future<void> connectNode({String newTypes}) async {
    String endpoint = store.settings.endpoint.value;
    int isIpse = store.settings.endpoint.info == "ipse" ? 1 : 0;
    // do connect
    String types = newTypes != null ? newTypes : '';

    String res =
        await evalJavascript('settings.connect("$endpoint",$isIpse,$types)');
    print("==============+++++++$res");
    if (res == null) {
      print('connect failed');
      store.settings.setNetworkName(null);
      return;
    }
    await fetchNetworkProps();
  }

  Future<void> changeNode() async {
    store.settings.setNetworkLoading(true);
    store.staking.clearState();
    store.ipse.clearState();
    launchWebview();
  }

  Future<void> fetchNetworkProps() async {
    // fetch network info
    List<dynamic> info = await evalJavascript('settings.fetchNetworkInfo()');
    // List<dynamic> info = await Future.wait([
    //   evalJavascript('settings.getNetworkConst()'),
    //   evalJavascript('settings.getNetworkPropoerties()'),
    //   evalJavascript('api.rpc.system.chain()'),
    // ]);
    store.settings.setNetworkConst(info[0]);
    store.settings.setNetworkState(info[1]);
    store.settings.setNetworkName(info[2]);
    if (store.account.accountList.length > 0) {
      // reset account address format

      loadAccountData();
    }

  }


  loadAccountData() async {
    // fetch account balance
    if (store.account.accountList.length > 0) {
      // fetch account balance
      ipse.subBalanceChange();
      ipse.subNewHeadsChange();
      await ipse.fetchGlobalData();
     
      
      await Future.wait([
        account.fetchAccountsIndex(),
        // assets.fetchBalance(),
        staking.fetchAccountStaking(),
        account.fetchAccountsBonded(
            store.account.accountList.map((i) => i.pubKey).toList()),
      ]);
      account.getPubKeyIcons([store.account.currentAccount.pubKey]);
    }
  }

  Future<void> updateBlocks(List txs) async {
    Map<int, bool> blocksNeedUpdate = Map<int, bool>();
    txs.forEach((i) {
      int block = i['attributes']['block_id'];
      if (store.assets.blockMap[block] == null) {
        blocksNeedUpdate[block] = true;
      }
    });
    String blocks = blocksNeedUpdate.keys.join(',');
    var data = await evalJavascript('account.getBlockTime([$blocks])');

    store.assets.setBlockMap(data);
  }

  Future<String> subscribeBestNumber(Function callback) async {
    final String channel = _getEvalJavascriptUID().toString();
    subscribeMessage(
        'settings.subscribeMessage("chain", "bestNumber", [], "$channel")',
        channel,
        callback);
    return channel;
  }

  Future<void> subscribeMessage(
    String code,
    String channel,
    Function callback,
  ) async {
    _msgHandlers[channel] = callback;
    evalJavascript(code, allowRepeat: true);
  }

  Future<void> unsubscribeMessage(String channel) async {
    _web.evalJavascript('unsub$channel()');
  }

  Future<List> getExternalLinks(GenExternalLinksParams params) async {
    final List res = await evalJavascript(
      'settings.genLinks(${jsonEncode(GenExternalLinksParams.toJson(params))})',
      allowRepeat: true,
    );
    return res;
  }
}
