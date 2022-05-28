import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:telegram_flutter/core/controller/emoji_controller.dart';
import 'package:telegram_flutter/core/utils/ext.dart';
import 'package:telegram_flutter/presentation/globalWidgets/improvedScrolling/lazy_load_scrollview.dart';
import 'package:telegram_flutter/presentation/globalWidgets/improvedScrolling/responsiveGridList/responsive_grid_list.dart';

class AppDialogs {
  int page = 1;
  int limit = 0;

  void showLottiePicker(
      BuildContext context, Function(String) onEmojiSelected) {
    double _value = kIsWeb ? 50 : 23;
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: (MediaQuery.of(context).size.height / 2) - 50,
        maxWidth: context.isHorizontalScreen()
            ? double.infinity
            : MediaQuery.of(context).size.width / 2,
      ),
      context: context,
      builder: (context) {
        return GetBuilder<EmojiController>(
          autoRemove: false,
          builder: (controller) {
            return StatefulBuilder(builder: (context, setState) {
              return Stack(
                children: [
                  Container(
                    height: 60,
                    child: Slider(
                      min: 0,
                      max: 100,
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: LazyLoadScrollView(
                      child: ResponsiveGridList(
                        horizontalGridMargin: 10,
                        verticalGridMargin: 10,
                        minItemWidth: (_value < 15) ? 15 * 3 : _value * 3,
                        children: List.generate(
                          controller.showList.length,
                          (index) => GestureDetector(
                            onTap: () {
                              blurDialog(
                                context,
                                message: "are you sure to send this ?",
                                onYesPressed: () {
                                  onEmojiSelected.call(controller.showList[index]);
                                  Navigator.pop(context);
                                },
                              );
                            },
                            child: Lottie.asset(
                                "assets/tgs/${controller.showList[index]}"),
                          ),
                        ),
                      ),
                      onEndOfPage: () => controller.loadMore(),
                    ),
                  )
                ],
              );
            });
          },
        );
      },
    );
  }

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
