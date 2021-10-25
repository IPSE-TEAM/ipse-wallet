
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/service/substrate_api/api.dart';
import 'package:ipsewallet/store/app.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/loading_widget.dart';
import 'package:ipsewallet/widgets/my_appbar.dart';
import 'package:ipsewallet/widgets/no_data.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class ClaimRecord extends StatefulWidget {
  ClaimRecord(this.store);

  static final String route = '/my/claimRecord';
  final AppStore store;
  @override
  _ClaimRecordState createState() => _ClaimRecordState(store);
}

class _ClaimRecordState extends State<ClaimRecord> {
  _ClaimRecordState(this.store);

  final AppStore store;
  List list;

  Future _getData() async {
    List res = await webApi.ipse.fetchIpseClaimRecord();
    if (res != null && mounted) {
      setState(() {
        list = res;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Widget mainWiget;
      if (list == null) {
        mainWiget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: Adapt.px(200),
            ),
            LoadingWidget(),
          ],
        );
      } else if (list.isEmpty) {
        mainWiget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: Adapt.px(200),
            ),
            NoData(),
          ],
        );
      } else {
        mainWiget = Column(
          children: list.map<Widget>((item) {
            return Container(
              color: item[1][0] == "Active" ? Colors.white : Color(0xFFEFF1F3),
              margin: EdgeInsets.only(bottom: 12.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 13),
                  isThreeLine: true,
                  title: item[1][0] == 'Active'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item[1][1].toString() + " POST",
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: Adapt.px(
                                  I18n.of(context).locale.languageCode == 'zh'
                                      ? 112
                                      : 128),
                              height: Adapt.px(54),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Adapt.px(27)),
                                  bottomLeft: Radius.circular(Adapt.px(27)),
                                ),
                                color: item[1][0] == "Active"
                                    ? Config.themeColor
                                    : Color(0xFFC0C3C6),
                              ),
                              child: Text(
                                I18n.of(context).ipse["success"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Adapt.px(26),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          item[1][1].toString() + " POST",
                        ),
                  subtitle: Container(
                    padding: const EdgeInsets.only(right: 13),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'TX Hash:  ',
                              style: TextStyle(color: Config.color666),
                            ),
                            Flexible(
                              child: Text(
                                Fmt.address(
                                    (item[0][1] as String).substring(2)),
                                style: TextStyle(color: Config.color666),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            IconButton(
                              icon: Image.asset('assets/images/a/copy999.png'),
                              onPressed: () {
                                copy(context, item[0][1].substring(2));
                              },
                            ),
                          ],
                        ),
                        item[1][0] != 'Active'?Row(
                          children: [
                            Text(
                              I18n.of(context).ipse['re-submit'],
                              style: TextStyle(color: Config.errorColor),
                            ),
                          ],
                        ):Container(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }
      return Scaffold(
        appBar: myAppBar(
          context,
          I18n.of(context).ipse['claimRecord'],
        ),
        body: RefreshLoadmore(
          child: mainWiget,
          isLastPage: false,
          onRefresh: _getData,
        ),
      );
    });
  }
}
