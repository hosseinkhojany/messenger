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

  void showLottiePicker(BuildContext context) {
    showModalBottomSheet(
      constraints: BoxConstraints(
        maxHeight: (MediaQuery.of(context).size.height / 2) - 50,
        maxWidth: context.isHorizontalScreen() ?  double.infinity : MediaQuery.of(context).size.width / 2,
      ),
      context: context,
      builder: (context) {
        return GetBuilder<EmojiController>(
            autoRemove: false,
            builder: (controller) {
              return LazyLoadScrollView(
                child: ResponsiveGridList(
                  horizontalGridMargin: 10,
                  verticalGridMargin: 10,
                  minItemWidth: 75,
                  children: List.generate(
                    controller.showList.length,
                        (index) =>
                        Lottie.asset("assets/tgs/${controller.showList[index]}"),
                  ),
                ),
                onEndOfPage: () => controller.loadMore(),
              );
            },
        );
      },
    );
  }
}
