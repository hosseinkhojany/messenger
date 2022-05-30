import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:telegram_flutter/core/controller/emoji_controller.dart';
import 'package:telegram_flutter/core/utils/ext.dart';
import 'package:telegram_flutter/presentation/chatPage/components/dialogs.dart';
import 'package:telegram_flutter/presentation/globalWidgets/improvedScrolling/lazy_load_scrollview.dart';
import 'package:telegram_flutter/presentation/globalWidgets/improvedScrolling/responsiveGridList/responsive_grid_list.dart';

class ChatPageBottomSheets {
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
                              ChatPageDialogs().blurDialog(
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
}
