import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class Constants{


  static Size designSize = const Size(375, 812);
  static Map<Locale, String> languagesMap = {
    const Locale('en', 'US'): "English",
    const Locale('fa', 'IR') : "فارسی",
  };
}

enum MESSAGE_TYPE {
  text,
  image,
  video,
  audio,
  file,
  location,
  sticker,
  contact,
  voice,
  video_call,
  voice_call,
  lottie,
  gif,
}

extension GlobalBuildContextExt on BuildContext{

  bool isDesktop(){
    return Theme.of(this).platform == TargetPlatform.linux ||
        Theme.of(this).platform == TargetPlatform.macOS ||
        Theme.of(this).platform == TargetPlatform.windows;
  }
  bool isDesktopOrWeb(){
    return Theme.of(this).platform == TargetPlatform.linux ||
        Theme.of(this).platform == TargetPlatform.macOS ||
        Theme.of(this).platform == TargetPlatform.windows ||
        kIsWeb;
  }
  bool isMobile(){
    return Theme.of(this).platform == TargetPlatform.android ||
        Theme.of(this).platform == TargetPlatform.iOS;
  }

}
