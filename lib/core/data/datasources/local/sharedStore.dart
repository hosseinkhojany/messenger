import 'dart:async' show Future;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const userName = "userName";
const firstRun = "firstRun";

class SharedStore {
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    if (_prefsInstance != null) {
      return _prefsInstance!;
    } else {
      _prefsInstance = await SharedPreferences.getInstance();
      return _prefsInstance!;
    }
  }

  static String getString(String key, [String defValue = ""]) {
    return _prefsInstance!.getString(key) ?? defValue;
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefsInstance!.setString(key, value);
  }

  static bool getBool(String key, [bool defValue = false]) {
    return _prefsInstance!.getBool(key) ?? defValue;
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefsInstance!.setBool(key, value);
  }

  static String getUserName([String defValue = ""]) {
    return getString(userName, defValue);
  }

  static Future<bool> setUserName(String value) async {
    return setString(userName, value);
  }

  static bool isFirstRun([bool defValue = true]) {
    return getBool(firstRun, defValue);
  }

  static Future<bool> setFirstRun(bool value) async {
    return setBool(userName, value);
  }
}
