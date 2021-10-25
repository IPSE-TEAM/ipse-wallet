import 'package:flutter/material.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/utils/adapt.dart';

Map materialColor = {
 
  'green': {
    "primaryColor": 0xFF28C495,
    "primaryColorLight": 0xFF7FC5B0,
  },
  'purple': {
    "primaryColor": 0xFF7B1FA2,
    "primaryColorLight": 0xFF9C27B0,
  },
  'pink': {
    "primaryColor": 0xFFc2185b,
    "primaryColorLight": 0xFFd81b60,
  },
  'deeppink': {
    "primaryColor": 0xFFf50057,
    "primaryColorLight": 0xFFe91e63,
  },
  'blue': {
    "primaryColor": 0xFF009FE8,
    // "primaryColor": 0xFF1976D2,
    "primaryColorLight": 0xFF52b9e8,
  },
  'gray': {
    "primaryColor": 0xFFF8F8F8,
    "primaryColorLight": 0xFFF9F9F9,
  },
};

class AppTheme {
 
  
  static getThemeData() {
    Map mainColor = materialColor['blue']; 
    ThemeData themData = ThemeData(
      scaffoldBackgroundColor: Config.bgColor, 

      primaryColor: Color(mainColor["primaryColor"]), 
      primaryColorLight: Color(mainColor["primaryColorLight"]),
     
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        textTheme: ButtonTextTheme.normal,
        buttonColor: Color(mainColor["primaryColor"]),
        disabledColor: Color(0xFFCCCCCC),
      ),
      
      accentColor: Color(mainColor["primaryColor"]),

    
      appBarTheme: AppBarTheme(
        color: Color(materialColor['gray']["primaryColor"]),
        brightness: Brightness.light,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Config.color333),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Config.color333,
            fontSize: 20.0,
          ),
        ),
      ),

     
      iconTheme: IconThemeData(
        color: Color(mainColor["primaryColor"]),
      ),
      cardTheme: CardTheme(elevation: 0),
      textTheme: TextTheme(
        headline4: TextStyle(
          color: Config.color666,
          fontSize: Adapt.px(30),
        ),
       
        button: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation:MaterialStateProperty.all(0),
           side:
            MaterialStateProperty.all(BorderSide(color: Color(mainColor["primaryColor"]), width: 1)),
        
        )
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation:MaterialStateProperty.all(0),
        )
      ),
     
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          color: Colors.black87,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        fillColor: Colors.white,
        filled: true,
      ),
    );
    return themData;
  }
}



final appThemePolkadot = ThemeData(
  primarySwatch: Colors.pink,
  textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 24,
      ),
      headline2: TextStyle(
        fontSize: 22,
      ),
      headline3: TextStyle(
        fontSize: 20,
      ),
      headline4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      button: TextStyle(
        color: Colors.white,
        fontSize: 18,
      )),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.pink,
  textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 24,
      ),
      headline2: TextStyle(
        fontSize: 22,
      ),
      headline3: TextStyle(
        fontSize: 20,
      ),
      headline4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      button: TextStyle(
        color: Colors.white,
        fontSize: 18,
      )),
);

const MaterialColor kusamaBlack = const MaterialColor(
  0xFF222222,
  const <int, Color>{
    50: const Color(0xFF555555),
    100: const Color(0xFF444444),
    200: const Color(0xFF444444),
    300: const Color(0xFF333333),
    400: const Color(0xFF333333),
    500: const Color(0xFF222222),
    600: const Color(0xFF111111),
    700: const Color(0xFF111111),
    800: const Color(0xFF000000),
    900: const Color(0xFF000000),
  },
);

final appThemeKusama = ThemeData(
  primarySwatch: kusamaBlack,
  textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 24,
      ),
      headline2: TextStyle(
        fontSize: 22,
      ),
      headline3: TextStyle(
        fontSize: 20,
      ),
      headline4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      button: TextStyle(
        color: Colors.white,
        fontSize: 18,
      )),
);
