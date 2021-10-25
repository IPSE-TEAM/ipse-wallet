import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
 
  Widget myAppBar(BuildContext context,String title,{bool isBackFFF=false,bool isThemeBg=false,Color backgroundColor,List<Widget> actions}) {
    return AppBar(
      backgroundColor: isThemeBg?Theme.of(context).primaryColor:backgroundColor,
      leading: IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
        icon: Image.asset(isBackFFF||isThemeBg?'assets/images/a/back-fff.png':'assets/images/a/back.png'),
      ),
      brightness: isThemeBg?Brightness.dark:Brightness.light,
      centerTitle: true,
      title: Text(title,style: TextStyle(color: isThemeBg?Colors.white:Config.color333),),
      actions: actions,
    );
  }
