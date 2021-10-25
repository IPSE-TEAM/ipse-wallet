import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/utils/i18n/index.dart';
import 'package:ipsewallet/widgets/no_data.dart';

class ListTail extends StatelessWidget {
  ListTail({this.isEmpty, this.isLoading});
  final bool isLoading;
  final bool isEmpty;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16),
          child: isLoading
              ? CupertinoActivityIndicator()
              : isEmpty
                  ? NoData()
                  : Text(
                      I18n.of(context).assets['end'],
                      style: TextStyle(fontSize: 15, color: Config.color999),
                    ),
        )
      ],
    );
  }
}
