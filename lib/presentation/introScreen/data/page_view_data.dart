import 'package:telegram_flutter/gen/assets.gen.dart';

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
      subtitle: '',
      imagePath: Assets.images.beautifulMessenger.path),
  PageViewData(
      title: 'Personalizable',
      subtitle: '',
      imagePath: Assets.images.beautifulMessenger.path),
  PageViewData(
      title: 'Cross platform',
      subtitle: '',
      imagePath: Assets.images.crossPlatform.path),
  PageViewData(
      title: 'Open Source',
      subtitle: '',
      imagePath:Assets.images.openSource.path),
];
