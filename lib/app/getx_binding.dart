import 'package:get/get.dart';
import 'package:telegram_flutter/core/controller/emoji_controller.dart';

class GetxBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => EmojiController());
  }
}