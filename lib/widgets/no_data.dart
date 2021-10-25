import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/utils/adapt.dart';
import 'package:ipsewallet/utils/i18n/index.dart';

class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/no_data.png',width: Adapt.px(100),color: Color(0xFFbcbcbc),),
          SizedBox(
            height: 15,
          ),
          Text(
            I18n.of(context).home['data.empty'],
            style: TextStyle(color: Config.color999),
          ),
        ],
      ),
    );
  }
}
