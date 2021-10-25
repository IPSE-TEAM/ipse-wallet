import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipsewallet/model/poc_register_status_model.dart';

class LocalStorage {
  static const customTypesKey = 'custom_types';
  static const searchResultKey = 'search_result';
  static const useBioFingerprintKey = 'use_bio_fingerprint';
  static const accountsKey = 'wallet_account_list';
  static const passwordKey = 'password';
  static const saleTaxKey = 'sale_tax';
  static const userInfoKey = 'user_info';
  static const customEnterPointListInfoKey = 'custom_enter_point_list';
  static const registerStatusKey = 'register_status';
  static const receiveAddressesKey = 'receive_addresses_list';
  static const currentAccountKey = 'wallet_current_account';
  static const contactsKey = 'wallet_contact_list';
  static const localeKey = 'wallet_locale';
  static const endpointKey = 'wallet_endpoint';
  static const customSS58Key = 'wallet_custom_ss58';
  static const seedKey = 'wallet_seed';
  static const customKVKey = 'wallet_kv';

  static final storage = new _LocalStorage();

 static Future<void> setCustomTypes(
      String customTypes) async {
    return storage.setKV(customTypesKey, customTypes);
  }

 static Future<String> getCustomTypes() async {
    return storage.getKV(customTypesKey);
  }

  Future<void> setSearhResult(
      List<Map<String, dynamic>> searhResultList) async {
    return storage.setKV(saleTaxKey, searhResultList);
  }

  Future<List<Map<String, dynamic>>> getSearhResult() async {
    return storage.getList(searchResultKey);
  }


  static Future clearAllLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    keys.map((e) => prefs.remove(e));
  }

  static Future<void> setUseBioFingerprint(
      bool useBioFingerprint, String publicKey) async {
    String useBioFingerprintMap = await storage.getKV(useBioFingerprintKey);
    Map map;
    try {
      map = useBioFingerprintMap != null
          ? jsonDecode(useBioFingerprintMap)
          : Map();
    } catch (e) {
      print(e);
      map = Map();
    }

    map[publicKey] = useBioFingerprint;

    return storage.setKV(useBioFingerprintKey, jsonEncode(map));
  }

  static Future<bool> getUseBioFingerprint(String publicKey) async {
    String useBioFingerprintMap = await storage.getKV(useBioFingerprintKey);
    if (useBioFingerprintMap == null) return false;
    try {
      Map map = jsonDecode(useBioFingerprintMap);
      bool isUse = map[publicKey];
      return isUse == null ? false : isUse;
      // return isUse==null?false:isUse=='true';
    } catch (e) {
      return false;
    }
  }

  static Future<void> setPassword(String password, String publicKey) async {
    String passwordMap = await storage.getKV(passwordKey);
    Map map;
    try {
      map = passwordMap != null ? jsonDecode(passwordMap) : Map();
    } catch (e) {
      print(e);
      map = Map();
    }
    map[publicKey] = password;
    return storage.setKV(passwordKey, jsonEncode(map));
  }

  static Future<String> getPassword(String publicKey) async {
    String passwordMap = await storage.getKV(passwordKey);
    if (passwordMap == null) return null;
    try {
      Map map = jsonDecode(passwordMap);
      return map[publicKey];
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> addCustomEnterPointListInfo(
      Map<String, dynamic> node) async {
    return storage.addItemToList(customEnterPointListInfoKey, node);
  }

  static Future<List<Map<String, dynamic>>> getCustomEnterPointList() async {
    return storage.getList(customEnterPointListInfoKey);
  }

  static Future<void> removeCustomEnterPointList() async {
    await storage.setKV(customEnterPointListInfoKey, null);
  }

  static Future<void> setPocRegisterStatus(
      PocRegisterStatusModel registerStatus) async {
    return storage.setKV(registerStatusKey,
        registerStatus == null ? null : jsonEncode(registerStatus.toJson()));
  }

  static Future<PocRegisterStatusModel> getPocRegisterStatus() async {
    String x = await storage.getKV(registerStatusKey);
    if (x != null) {
      return PocRegisterStatusModel.fromJson(jsonDecode(x));
    }
    return null;
  }

  static Future<void> setSaleTax(String saleTax) async {
    return storage.setKV(saleTaxKey, saleTax);
  }

  static Future<String> getSaleTax() async {
    return storage.getKV(saleTaxKey);
  }

  ///
  static Future<void> addReceiveAddresses(Map<String, dynamic> con) async {
    return storage.addItemToList(receiveAddressesKey, con);
  }

  ///
  static Future<void> addReceiveAddressesList(
      List<Map<String, dynamic>> list) async {
    return storage.setKV(receiveAddressesKey, jsonEncode(list));
  }

  static Future<void> removeReceiveAddresses(String symbol) async {
    return storage.removeItemFromList(receiveAddressesKey, 'symbol', symbol);
  }

  static Future<void> updateReceiveAddresses(Map<String, dynamic> con) async {
    return storage.updateItemInList(
        receiveAddressesKey, 'symbol', con['symbol'], con);
  }

  static Future<List<Map<String, dynamic>>> getReceiveAddresses() async {
    return storage.getList(receiveAddressesKey);
  }

  Future<void> addAccount(Map<String, dynamic> acc) async {
    return storage.addItemToList(accountsKey, acc);
  }

  Future<void> removeAccount(String pubKey) async {
    return storage.removeItemFromList(accountsKey, 'pubKey', pubKey);
  }

  Future<List<Map<String, dynamic>>> getAccountList() async {
    return storage.getList(accountsKey);
  }

  Future<void> setCurrentAccount(String pubKey) async {
    return storage.setKV(currentAccountKey, pubKey);
  }

  Future<String> getCurrentAccount() async {
    return storage.getKV(currentAccountKey);
  }

  Future<void> addContact(Map<String, dynamic> con) async {
    return storage.addItemToList(contactsKey, con);
  }

  Future<void> removeContact(String address) async {
    return storage.removeItemFromList(contactsKey, 'address', address);
  }

  Future<void> updateContact(Map<String, dynamic> con) async {
    return storage.updateItemInList(
        contactsKey, 'address', con['address'], con);
  }

  Future<List<Map<String, dynamic>>> getContactList() async {
    return storage.getList(contactsKey);
  }

  Future<void> setSeeds(String seedType, Map value) async {
    return storage.setKV('${seedKey}_$seedType', jsonEncode(value));
  }

  Future<Map> getSeeds(String seedType) async {
    String value = await storage.getKV('${seedKey}_$seedType');
    if (value != null) {
      return jsonDecode(value);
    }
    return {};
  }

  static Future<void> setKV(String key, Object value) async {
    // String str = await compute(jsonEncode, value);
    String str = jsonEncode(value);
    return storage.setKV('${customKVKey}_$key', str);
  }

  static Future<Object> getKV(String key) async {
    String value = await storage.getKV('${customKVKey}_$key');
    if (value != null) {
      // Object data = await compute(jsonDecode, value);
      Object data = jsonDecode( value);
      return data;
    }
    return null;
  }

  Future<void> setObject(String key, Object value) async {
    // String str = await compute(jsonEncode, value);
    String str = jsonEncode(value);
    return storage.setKV('${customKVKey}_$key', str);
  }

  Future<Object> getObject(String key) async {
    String value = await storage.getKV('${customKVKey}_$key');
    if (value != null) {
      // Object data = await compute(jsonDecode, value);
      Object data = jsonDecode(value);
      return data;
    }
    return null;
  }

  Future<void> setAccountCache(
      String accPubKey, String key, Object value) async {
    Map data = await getKV(key);
    if (data == null) {
      data = {};
    }
    data[accPubKey] = value;
    setKV(key, data);
  }

  Future<Object> getAccountCache(String accPubKey, String key) async {
    Map data = await getKV(key);
    if (data == null) {
      return null;
    }
    return data[accPubKey];
  }

  // cache timeout 10 minutes
  static const int customCacheTimeLength = 10 * 60 * 1000;

  static bool checkCacheTimeout(int cacheTime) {
    return DateTime.now().millisecondsSinceEpoch - customCacheTimeLength >
        cacheTime;
  }
}

class _LocalStorage {
  Future<String> getKV(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> setKV(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  Future<void> addItemToList(String storeKey, Map<String, dynamic> acc) async {
    var ls = new List<Map<String, dynamic>>();

    String str = await getKV(storeKey);
    if (str != null) {
      Iterable l = jsonDecode(str);
      ls = l.map((i) => Map<String, dynamic>.from(i)).toList();
    }

    ls.add(acc);

    setKV(storeKey, jsonEncode(ls));
  }

  Future<void> removeItemFromList(
      String storeKey, String itemKey, String itemValue) async {
    var ls = await getList(storeKey);
    ls.removeWhere((item) => item[itemKey] == itemValue);
    setKV(storeKey, jsonEncode(ls));
  }

  Future<void> updateItemInList(String storeKey, String itemKey,
      String itemValue, Map<String, dynamic> itemNew) async {
    var ls = await getList(storeKey);
    ls.removeWhere((item) => item[itemKey] == itemValue);
    ls.add(itemNew);
    setKV(storeKey, jsonEncode(ls));
  }

  Future<List<Map<String, dynamic>>> getList(String storeKey) async {
    var res = new List<Map<String, dynamic>>();

    String str = await getKV(storeKey);
    if (str != null) {
      Iterable l = jsonDecode(str);
      res = l.map((i) => Map<String, dynamic>.from(i)).toList();
    }
    return res;
  }
}
