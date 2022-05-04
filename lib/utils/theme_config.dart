import 'package:co_sport_map/utils/contansts.dart';
import 'package:flutter/material.dart';

enum MyTheme { light, dark }
String? _darkmode = Constants.prefs.getString('darkmode');

class ThemeNotifier extends ChangeNotifier {
  static List<ThemeData> themes = [
    ThemeData(
      dividerColor: Colors.transparent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: const CardTheme(
        shadowColor: Color(0x1100d2ff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        elevation: 10,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xffCBC6CB),
        ),
        filled: true,
        fillColor: Colors.white,
        hoverColor: Colors.white,
        alignLabelWithHint: true,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: Color(0xffF3F0F4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: Color(0xffF3F0F4)),
        ),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        color: Color(0xffF7F7FF),
        elevation: 0,
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      primaryColor: const Color(0xff0081FE),
      primaryColorLight: const Color(0xff0081FE),
      primaryColorDark: const Color(0xff0081FE),
      accentColor: const Color(0xff0081FE),
      buttonColor: const Color(0xff0081FE),
      scaffoldBackgroundColor: const Color(0xffF7FAFF),
      fontFamily: 'Montserrat',
      brightness: Brightness.light,
      primaryColorBrightness: Brightness.light,
      backgroundColor: const Color(0xff393E46),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: Color(0xff0081FE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: Color(0xff0081FE),
      ),
    ),
    ThemeData(
      dividerColor: Colors.transparent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardTheme: const CardTheme(
        color: Color(0xff1d1d1d),
        shadowColor: Color(0x00333333),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: Color(0xff2dadc2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        foregroundColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.black45,
        elevation: 0,
        brightness: Brightness.dark,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: Color(0xff555555),
        ),
        filled: true,
        fillColor: Color(0xff272727),
        hoverColor: Colors.white,
        alignLabelWithHint: true,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: Color(00000000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: Color(00000000)),
        ),
      ),
      primaryColor: const Color(0xff2dadc2),
      primaryColorLight: const Color(0xff00d2ff),
      primaryColorDark: const Color(0xff0052ff),
      accentColor: const Color(0xff00d2ff),
      buttonColor: const Color(0xff00d2ff),
      scaffoldBackgroundColor: const Color(0xff040505),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black45,
        elevation: 0,
        selectedItemColor: Color(0xff2dadc2),
      ),
      fontFamily: 'Montserrat',
      brightness: Brightness.dark,
      backgroundColor: const Color(0xffffffff),
    ),
  ];
  MyTheme _current = (_darkmode == "false" || _darkmode == null)
      ? MyTheme.light
      : MyTheme.dark;

  ThemeData _currentTheme =
      (_darkmode == "false" || _darkmode == null) ? themes[0] : themes[1];

  set currentTheme(theme) {
    if (theme != null) {
      _current = theme;
      _currentTheme = _current == MyTheme.light ? themes[0] : themes[1];
      notifyListeners();
    }
  }

  get myTheme => _current;

  ThemeData get currentTheme => _currentTheme;

  void switchTheme() {
    if (_current == MyTheme.light) {
      Constants.prefs.setString("darkmode", "true");
      currentTheme = MyTheme.dark;
    } else {
      Constants.prefs.setString("darkmode", "false");
      currentTheme = MyTheme.light;
    }
  }
}
