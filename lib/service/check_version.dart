import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:ipsewallet/service/request_service.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/download_dialog.dart';

class CheckVersion {
  String version = '';

  String _newVersion = '';

  String _downloadUrl;

  var homeI18n;


  static Future<String> getPackageVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  void _setNewVersion(newVersion, downloadUrl) {
    _newVersion = newVersion;
    _downloadUrl = downloadUrl;
  }


  void getNewVersion(context) async {
    version = await getPackageVersion();
    print('version:$version');
    var response = await RequestService.getNewVersionData();
    if (response.code != 111) {
      String url;
      List versionList = response.data["versionlist"];
      if (versionList.isNotEmpty && versionList.first != null) {
        url = versionList.first["url"];
        var changes = I18n.of(context).locale.languageCode == 'zh'
            ? versionList.first["changes"]
            : versionList.first["changesEn"];
        _setNewVersion(versionList.first["version"], url);
        print('newversion:$_newVersion');
        if (changes == null) {
          changes = [];
        }
        _showUpdateDiloag(context, changes);
      }
    }
  }

  _showUpdateDiloag(BuildContext context, List changes) {
    if (version != null && _newVersion != null && version != _newVersion) {
      homeI18n = I18n.of(context).home;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            homeI18n['appStoreDowload'],
          ),
          content: changes.isEmpty
              ? null
              : Container(
                  height: 100,
                  padding: EdgeInsets.all(5),
                  color: Color(0xFFF9F9F9),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: changes
                          .map((e) => Text(
                                e,
                                style: TextStyle(fontSize: Adapt.px(25)),
                              ))
                          .toList(),
                    ),
                  ),
                ),
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
              
              child: Text(homeI18n['downloadNow']),
              onPressed: () {
                Navigator.pop(context);
                 if (Platform.isAndroid) {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DownloadDialog(_downloadUrl);
                    },
                  );
                }
              },
            ),
          ],
        ),
      );
    }
  }


}
