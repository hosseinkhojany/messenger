import 'package:hive/hive.dart';
import 'package:telegram_flutter/core/data/config/hive_config.dart';

const USER_TOKEN = "USER_TOKEN";
const USER = "USER";

class SharedStore{

  static Box _getBox() {
    return Hive.box(SHARED_CONFIG_BOX);
  }

  static void setUserName(String value) => _getBox().put(USER_TOKEN, value);
  static String getUserName() => _getBox().get(USER_TOKEN, defaultValue: "");
  static String getUser() => _getBox().get(USER, defaultValue: "");

}


