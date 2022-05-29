import 'package:telegram_flutter/presentation/introScreen/resources/asset_manager.dart';

class PageViewData {
  final String title;
  final String subtitle;
  final String imagePath;

  PageViewData(
      {required this.title, required this.subtitle, required this.imagePath});
}

final pageViewData = [
  PageViewData(
      title: 'Beautiful Messenger',
      subtitle: 'This is a beautiful messenger',
      imagePath: AssetManager.beautifulMessengerPath),
  PageViewData(
      title: 'Personalizable',
      subtitle: '',
      imagePath: AssetManager.beautifulMessengerPath),
  PageViewData(
      title: 'Cross platform',
      subtitle: '',
      imagePath: AssetManager.crossPlatformPath),
  PageViewData(
      title: 'Open Source',
      subtitle: '',
      imagePath: AssetManager.openSourcerPath),
];
