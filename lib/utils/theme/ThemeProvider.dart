
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;
  late int _selectedThemeIndex;
  final secure_storage = const FlutterSecureStorage();
  //late SharedPreferences prefs;
  late Color _active;
  ThemeProvider({required int theme}) {
    if (theme == 0) {
      _active = ColorProvider().primaryDeepGreen;
    } else if (theme == 1) {
      _active = ColorProvider().primaryDeepRed;
    } else if (theme == 2) {
      _active = ColorProvider().primaryDeepPurple;
    } else if (theme == 3) {
      _active = ColorProvider().primaryDeepOrange;
    } else if (theme == 4) {
      _active = ColorProvider().primaryDeepBlue;
    } else if (theme == 5) {
      _active = ColorProvider().primaryDeepBlack;
    } else if (theme == 6) {
      _active = ColorProvider().primaryDeepTeal;
    } else if (theme == 7) {
      _active = ColorProvider().primaryDeepCheetah;
    } else {
      _active = ColorProvider().primaryDeepGreen;
    }
    _selectedThemeIndex = theme;
    _setupBars(theme);
    //ready for test
  }

  ThemeData get getTheme => _selectedTheme;
  int getThemeIndex(){
    return _selectedThemeIndex;
  }
  Color get getColor => _active;

  Future<void> changeTheme(int theme) async {
    //prefs = await SharedPreferences.getInstance();
    if (theme == 0) {
      _active = ColorProvider().primaryDeepGreen;
    } else if (theme == 1) {
      _active = ColorProvider().primaryDeepRed;
    } else if (theme == 2) {
      _active = ColorProvider().primaryDeepPurple;
    } else if (theme == 3) {
      _active = ColorProvider().primaryDeepOrange;
    } else if (theme == 4) {
      _active = ColorProvider().primaryDeepBlue;
    } else if (theme == 5) {
      _active = ColorProvider().primaryDeepBlack;
    } else if (theme == 6) {
      _active = ColorProvider().primaryDeepTeal;
    } else if (theme == 7) {
      _active = ColorProvider().primaryDeepCheetah;
    } else {
      _active = ColorProvider().primaryDeepGreen;
    }
    _selectedThemeIndex = theme;
    secure_storage.write(key: "theme", value: theme.toString());
    //await prefs.setInt("theme", theme);
//notifying all the listeners(consumers) about the change.
    notifyListeners();
    _setupBars(theme);
  }


  Color _themeColor(int theme) {
    switch (theme) {
      case 0:
        return ColorProvider().primaryDeepGreen;
      case 1:
        return ColorProvider().primaryDeepRed;
      case 2:
        return ColorProvider().primaryDeepPurple;
      case 3:
        return ColorProvider().primaryDeepOrange;
      case 4:
        return ColorProvider().primaryDeepBlue;
      case 5:
        return ColorProvider().primaryDeepBlack;
      case 6:
        return ColorProvider().primaryDeepTeal;
      case 7:
        return ColorProvider().primaryDeepCheetah;
    }
    return ColorProvider().primaryDeepGreen;
  }
  _setupBars(int theme){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: _themeColor(theme),
      // navigation bar color
      statusBarColor: _themeColor(theme),
      // status bar color
    ));
  }

}
