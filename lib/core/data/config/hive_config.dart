import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

String SHARED_CONFIG_BOX = "SHARED_CONFIG";
class HiveConfig{

  static init() async {
    await Hive.initFlutter();
    await openSharedConfigBox();
  }

  static openSharedConfigBox() async {
    await Hive.openBox(SHARED_CONFIG_BOX);
  }

}