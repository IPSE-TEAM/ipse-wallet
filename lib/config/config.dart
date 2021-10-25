import 'package:flutter/material.dart';

class Config {
  static const String tokenSymbol = "IPSE";
  static const int ss58 = 42;

  static String logo = "assets/logo.png";
  static String fullLogo = "assets/logo-full-color.png";
  static String noData = "assets/no_data.png";
  static String tutorialUrl = "https://github.com/IPSE-TEAM/ipse-core/blob/ipse/document";
  static String uri = "ipfs.guide";
  static List<String> categoryList = [
    "video",
    "image",
    "audio",
    "html",
    "package",
    'dir',
    "other"
  ];
  static List<String> urlList = [
    'https://dweb.link',
    'https://astyanax.io',
    "https://gateway.ipfs.io",
    'https://crustwebsites.net',
    'https://ipfs.drink.cafe',
    'https://ipfs.taxi',
    'https://10.via0.com',
    'https://ipfs.io'
  ];
  static String testHash =
      "/ipfs/Qmaisz6NMhDB51cCvNWa1GMS7LU1pAxdF4Ld6Ft9kZEP2a";
  static String baseUrl = "https://www.ipse.io";

  static const List<String> networkList = [
    "ipse",
  ];


  static const List<String> supportNetworkList = ["polkadot", "kusama","ipse mainnet"];

  static const String eosAddr = "eosio.saving";
  static const Color themeColor = Color(0xFF009FE8);
  static const Color bgColor = Color(0xFFF8F8F8);
  static const Color color333 = Color(0xFF333333);
  static const Color color666 = Color(0xFF666666);
  static const Color color999 = Color(0xFF999999);
  static const Color secondColor = Colors.green;
  static const Color errorColor = Color(0xFFF14B79);


  static const double maxTipPercent = 0.1;

}

