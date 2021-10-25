import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipsewallet/pages/my/manage_account/manage_account.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/store/assets/types/balancesInfo.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/loading.dart';
import 'package:ipsewallet/utils/local_storage.dart';
import 'package:local_auth/error_codes.dart' as auth_error;


void showErrorMsg(String msg, {bool isLong = true}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}


void showSuccessMsg(String msg, {bool isLong = false}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showConfrim(
    BuildContext context, Widget title, String okText, Function okFn) {
  var homeI18n = I18n.of(context).home;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: title,
      actions: <Widget>[
        TextButton(
          child: Text(
            homeI18n['cancel'],
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text(okText,style:TextStyle(color:Theme.of(context).primaryColor)),
          onPressed: () {
            Navigator.pop(context);
            okFn();
          },
        ),
      ],
    ),
  );
}


void copy(context, text) {
  Clipboard.setData(ClipboardData(text: text));
  showSuccessMsg(I18n.of(context).home['copy']);
}


Future<String> showPasswordDialog(BuildContext context,String currentAccountPubKey,{bool isShowGoAuth=true}) async {
  final Map<String, String> dic = I18n.of(context).profile;
  final Map<String, String> accDic = I18n.of(context).account;
  final Api api = webApi;
  final TextEditingController _passCtrl = new TextEditingController();
  return await showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(dic['delete.confirm']),
        content: Padding(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            children: [
              CupertinoTextField(
                placeholder: dic['pass.old'],
                controller: _passCtrl,
                onChanged: (v) {
                  return Fmt.checkPassword(v.trim())
                      ? null
                      : accDic['create.password.error'];
                },
                obscureText: true,
                clearButtonMode: OverlayVisibilityMode.editing,
              ),
             isShowGoAuth? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(child: Text(I18n.of(context).home['unlock.bio.enable'],style:TextStyle(fontSize:Adapt.px(26))),onPressed: ()=> Navigator.of(context).pushNamed(ManageAccount.route)),
                ],
              ):Container(),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text(I18n.of(context).home['cancel']),
            onPressed: () {
              Navigator.of(context).pop();
              _passCtrl.clear();
            },
          ),
          CupertinoButton(
            child: Text(I18n.of(context).home['ok']),
            onPressed: () async {
              Loading.showLoading(context);
              var res = await api.account.checkAccountPassword(_passCtrl.text);
              Loading.hideLoading(context);
              if (res == null) {
                showErrorMsg(dic['pass.error']);
              } else {
                LocalStorage.setPassword(_passCtrl.text,currentAccountPubKey);
                Navigator.of(context).pop(_passCtrl.text);
              }
            },
          ),
        ],
      );
    },
  );
}

final String regexEmail =
    "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";


Future<String> doAuth(BuildContext context,String currentAccountPubKey) async {
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> availableBiometrics = [];
  String password;
  bool isUseFingerprint = await LocalStorage.getUseBioFingerprint(currentAccountPubKey);
  if (!isUseFingerprint) {
    password = await showPasswordDialog(context,currentAccountPubKey);
    return password;
  }
  password = await LocalStorage.getPassword(currentAccountPubKey);
  if (password == null) {
    password = await showPasswordDialog(context,currentAccountPubKey);
    return password;
  }
  try {
    bool canCheckBiometrics = await auth.canCheckBiometrics;

    if (canCheckBiometrics) {
      availableBiometrics = await auth.getAvailableBiometrics();
    }
    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      bool isAuth = await fingerprintAuth(auth, context);
      if (isAuth == false) {
        password = await showPasswordDialog(context,currentAccountPubKey);
      }
    } else {
      password = await showPasswordDialog(context,currentAccountPubKey);
    }
  } catch (e) {
    print(e);
    auth.stopAuthentication();
    showErrorMsg(I18n.of(context).home['fingerprint_error']);
    password = null;
  }
  return password;
}


Future<bool> fingerprintAuth(
    LocalAuthentication auth, BuildContext context) async {
  bool didAuthemticate = false;
  try {
    didAuthemticate = await auth.authenticate(
      androidAuthStrings: AndroidAuthMessages(
        biometricHint:'',
        cancelButton: I18n.of(context).home['cancel'],
        signInTitle: I18n.of(context).my['pleaseVerifyYourFingerprint'],
      ),
      localizedReason: I18n.of(context).my['pleaseVerifyYourFingerprint'],
      useErrorDialogs: true,
      biometricOnly: true,
    );
  } on PlatformException catch (e) {
    print(e);
    if (e.code == auth_error.notAvailable) {
      showErrorMsg('notAvailable');
    } else if (e.code == auth_error.passcodeNotSet) {
      
    } else if (e.code == auth_error.otherOperatingSystem) {
      
    } else if (e.code == auth_error.notEnrolled) {
      
    } else if (e.code == auth_error.lockedOut) {
      showErrorMsg(I18n.of(context).my['lockedOut']);
    } else if (e.code == auth_error.permanentlyLockedOut) {
      showErrorMsg(I18n.of(context).my['permanentlyLockedOut']);
    } else if (e.code == 'auth_in_progress') {
      auth.stopAuthentication();
    } else {
      showErrorMsg(I18n.of(context).home['error']);
    }
  }
  auth.stopAuthentication();
  return didAuthemticate;
}


num getTransferable(AppStore store) {
  int decimals = store.settings.networkState.tokenDecimals;
  String symbol = store.settings.networkState.tokenSymbol;
  BalancesInfo balancesInfo = store.assets.balances[symbol];
  String res = Fmt.token(balancesInfo.transferable, decimals);
  num transferable = num.tryParse(res.replaceAll(',', '')) ?? 0;
  return transferable;
}

String getTransferableToken(AppStore store) {
  int decimals = store.settings.networkState.tokenDecimals;
  String symbol = store.settings.networkState.tokenSymbol;
  BalancesInfo balancesInfo = store.assets.balances[symbol];
  String res = Fmt.token(balancesInfo.transferable, decimals);
  return res;
}

showColor(category) {
  switch (category) {
    case "html":
      return Colors.blue;
    case "video":
      return Colors.green;
    case "image":
      return Colors.purple;
    case "audio":
      return Colors.teal;
    case "package":
      return Colors.deepOrange;
    case "dir":
      return Colors.cyan;
    case "other":
      return Colors.blueGrey;
    default:
      return Colors.blue;
  }
}

String sizefilter(int limit) {
  var size = "";
  if (limit < 1024) {
    size = limit.toString() + " KB";
  } else if (limit < 0.1 * 1024 * 1024) {
    
    size = (limit / 1024).toStringAsFixed(2) + " MB";
  } else if (limit < 0.1 * 1024 * 1024 * 1024) {
    
    size = (limit / (1024 * 1024)).toStringAsFixed(2) + " GB";
  } else {
    
    size = (limit / (1024 * 1024 * 1024)).toStringAsFixed(2) + " TB";
  }
  var sizeStr = size + ""; 
  var index = sizeStr.indexOf("."); 
  var dou = sizeStr.substring(index + 1, index + 2); 
  if (dou == "00") {
    
    return sizeStr.substring(0, index) +
        sizeStr.substring(index + 3, index + 2);
  }
  return size;
}
