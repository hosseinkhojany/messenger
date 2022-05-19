
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class AppSnackBar{
  static show(String messsage){
    Get.snackbar("", messsage, colorText: Colors.white);
  }
}