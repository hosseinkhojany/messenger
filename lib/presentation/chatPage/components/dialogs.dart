import 'dart:ui';
import 'package:flutter/material.dart';

class ChatPageDialogs {
  blurDialog(BuildContext context,
      {String? title, String? message, Function? onYesPressed}) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (ctx, anim1, anim2) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: title == null ? null : Text(title),
        content: message == null ? null : Text(message),
        elevation: 6,
        actions: [
          GestureDetector(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("Yes"),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green,
              ),
            ),
            onTap: () {
              onYesPressed?.call();
            },
          ),
          GestureDetector(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text("No"),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          child: child,
          opacity: anim1,
        ),
      ),
      context: context,
    );
  }
}
