import 'package:flutter/material.dart';

extension ScreenSizeGameCardExt on BuildContext{
  double nameFieldWidth(){
    if(MediaQuery.of(this).size.width < MediaQuery.of(this).size.height){
      //use horizontal |
      return MediaQuery.of(this).size.width / 5;
    } else {
      //use vertical __
      return MediaQuery.of(this).size.width / 4;
    }
  }
}