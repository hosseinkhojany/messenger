import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EmojiController extends GetxController {

  RxInt page = 0.obs;
  int limit = 0;

  List<String> lotties = [];
  List<String> showList = [];

  @override
  void onInit() {
    rootBundle.loadString('assets/tgs/a.txt').then((value) {
      lotties = value.split(',');
      ever(page, (_) => fetchNew());
      loadMore();
    });
    super.onInit();
  }


  Future<void> fetchNew() async {
    limit = page.value * 50;
    showList = lotties.sublist(0, limit);
    update();
  }


  Future<void> loadMore() async {
    page.value += 1;
  }


}
