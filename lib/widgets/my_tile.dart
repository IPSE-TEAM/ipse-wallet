import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';

Widget myTile(
    {Widget leading,
    String title,
    Color titleColor,
    String trailing,
    bool noborder = false,
    bool noMore = false,
    void Function() onLongPress,
    GestureTapCallback onTap}) {
  return InkWell(
    onTap: onTap,
    onLongPress: onLongPress,
    child: Semantics(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          child: Row(
            children: <Widget>[
              leading == null
                  ? Padding(padding: EdgeInsets.fromLTRB(15.0, 10, 0, 10))
                  : Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                      child: leading),
              Expanded(
                child: Container(
                  decoration: noborder
                      ? null
                      : BoxDecoration(
                          border: Border(
                          bottom:
                              BorderSide(color: Color(0xFFE6E6E6), width: 0.0),
                        )),
                  padding: EdgeInsets.fromLTRB(0, 18.0, 15.0, 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor ?? Config.color333,
                          fontSize: 15.0,
                        ),
                      ),
                      Container(
                          child: Row(
                        children: <Widget>[
                          Text(
                            trailing ?? '',
                            style: TextStyle(color: Config.color999),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          noMore
                              ? Container()
                              : Image.asset('assets/images/a/more.png')
                        ],
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
