import 'package:flutter/material.dart';
import 'package:ipsewallet/utils/format.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/store/account/account.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/widgets/address_icon.dart';
import 'package:ipsewallet/widgets/gradient_bg.dart';

class AddressQR extends StatefulWidget {
  static const route = '/my/addressQR';
  AddressQR(this.accountStore);
  final AccountStore accountStore;
  @override
  _AddressQRState createState() => _AddressQRState();
}

class _AddressQRState extends State<AddressQR> {
  @override
  Widget build(BuildContext context) {
    final String _address = widget.accountStore.currentAddress;

    return Scaffold(
      body: GredientBg(
        title: I18n.of(context).my['myAccountAddress'],
        height: Adapt.px(609),
        child: Container(
          margin: EdgeInsets.only(bottom: Adapt.px(40)),
          padding: EdgeInsets.only(top: Adapt.px(40), bottom: Adapt.px(100)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(35, 174, 132, 0.12),
                offset: Offset(0, Adapt.px(4)),
                blurRadius: Adapt.px(12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AddressIcon(
                '',
                pubKey: widget.accountStore.currentAccount.pubKey,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.accountStore.currentAccount.name ?? 'name',
                style: TextStyle(fontSize: 18, color: Config.color333),
              ),
              SizedBox(
                height: 15,
              ),
              QrImage(
                data: _address,
                version: QrVersions.auto,
                size: 200.0,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: 300,
                child: Text(_address,
                    style: TextStyle(
                      color: Config.color666,
                      fontSize: Adapt.px(20),
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: Adapt.px(370),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          vertical: Adapt.px(20),
                        ),
                        color: Config.themeColor,
                        child: Text(
                          I18n.of(context).my['copy'],
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          copy(context, _address);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
