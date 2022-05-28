import 'package:flutter/material.dart';
import 'package:telegram_flutter/gen/colors.gen.dart';
import 'package:telegram_flutter/presentation/globalWidgets/icon_shadow.dart';

import '../../../core/utils/ext.dart';

class CustomTabBar extends StatefulWidget {
  final List<CustomTabBarItem> customTabBarItems;
  final Function(int)? onSelectedChanged;
  final double? height;
  final double? width;
  final CustomTabBarOrientation? orientation;
  final Color? background;
  int? selected;
  final Color? iconColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  int _selected = -1;

  CustomTabBar(
      {Key? key,
      required this.customTabBarItems,
      this.onSelectedChanged,
      this.height,
      this.width,
      this.orientation,
      this.background,
      this.selected,
      this.iconColor,
      this.selectedColor,
      this.unselectedColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomTabBarState();
  }
}

class _CustomTabBarState extends State<CustomTabBar> {
  double padding20 = 20;
  double padding10 = 10;
  double itemSize = 35;

  @override
  void initState() {
    widget._selected = widget.selected ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: setHeight(),
      width: setWith(),
      decoration: BoxDecoration(
        color: widget.background,
        borderRadius: BorderRadius.all(
          Radius.circular(17),
        ),
        shape: BoxShape.rectangle,
      ),
      child: SingleChildScrollView(
        child: widget.orientation == CustomTabBarOrientation.horizontal
            ? Column(
                children: createListTabColumn(
                    widget.orientation ?? CustomTabBarOrientation.vertical))
            : Row(
                children: createListTabRow(
                    widget.orientation ?? CustomTabBarOrientation.vertical)),
      ),
    );
  }

  List<Widget> createListTabColumn(CustomTabBarOrientation orientation) {
    List<Widget> tabs = [];
    for (int i = 0; i < widget.customTabBarItems.length; i++) {
      CustomTabBarItem item = widget.customTabBarItems[i];
      bool itSelected = widget._selected == i;
      Widget tab = GestureDetector(
        onTap: () {
          widget.onSelectedChanged?.call(i);
          setState(() {
            widget._selected = i;
          });
        },
        child: Row(
          children: [
            Padding(
              padding: edgeInset(i, orientation),
              child: SizedBox(
                height: itemSize,
                width: itemSize,
                child: setIcon(item, itSelected),
              ),
            ),
            Padding(
              padding: edgeInsetBannerColor(i, orientation),
              child: Container(
                width: 2,
                height: itemSize,
                decoration: BoxDecoration(
                  color: itSelected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(99),
                  gradient: itSelected
                      ? LinearGradient(
                          colors: [
                            ColorName.gradientColor1,
                            ColorName.gradientColor2,
                          ],
                          begin: Alignment(-1.0, -2.0),
                          end: Alignment(1.0, 2.0),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      );
      tabs.add(tab);
    }
    return tabs;
  }

  List<Widget> createListTabRow(CustomTabBarOrientation orientation) {
    List<Widget> tabs = [];
    for (int i = 0; i < widget.customTabBarItems.length; i++) {
      CustomTabBarItem item = widget.customTabBarItems[i];
      bool itSelected = widget._selected == i;
      Widget tab = GestureDetector(
        onTap: () {
          widget.onSelectedChanged?.call(i);
          setState(() {
            widget._selected = i;
          });
        },
        child: Column(
          children: [
            Padding(
              padding: edgeInset(i, orientation),
              child: SizedBox(
                height: itemSize,
                width: itemSize,
                child: setIcon(item, itSelected),
              ),
            ),
            Padding(
              padding: edgeInsetBannerColor(i, orientation),
              child: Container(
                width: itemSize,
                height: 2,
                decoration: BoxDecoration(
                  color: itSelected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(99),
                  gradient: itSelected
                      ? LinearGradient(
                          colors: [
                            ColorName.gradientColor1,
                            ColorName.gradientColor2,
                          ],
                          begin: Alignment(-1.0, -2.0),
                          end: Alignment(1.0, 2.0),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      );
      tabs.add(tab);
    }
    return tabs;
  }

  EdgeInsets edgeInset(int index, CustomTabBarOrientation orientation) {
    if (index == widget.customTabBarItems.length - 1) {
      return orientation == CustomTabBarOrientation.horizontal
          ? EdgeInsets.only(
              left: padding10,
              top: padding10,
              right: padding10,
              bottom: padding20)
          : EdgeInsets.only(
              left: padding10,
              top: padding10,
              right: padding20,
              bottom: padding10);
    } else if (index == 0) {
      return orientation == CustomTabBarOrientation.horizontal
          ? EdgeInsets.only(
              left: padding10,
              top: padding20,
              right: padding10,
              bottom: padding10)
          : EdgeInsets.only(
              left: padding20,
              top: padding10,
              right: padding10,
              bottom: padding10);
    } else {
      return EdgeInsets.all(padding10);
    }
  }

  EdgeInsets edgeInsetBannerColor(
      int index, CustomTabBarOrientation orientation) {
    if (index == widget.customTabBarItems.length - 1) {
      return orientation == CustomTabBarOrientation.horizontal
          ? EdgeInsets.only(
              top: padding10,
              bottom: padding20,
            )
          : EdgeInsets.only(
              left: padding10,
              right: padding20,
            );
    } else if (index == 0) {
      return orientation == CustomTabBarOrientation.horizontal
          ? EdgeInsets.only(
              top: padding20,
              bottom: padding10,
            )
          : EdgeInsets.only(
              left: padding20,
              right: padding10,
            );
    } else {
      return orientation == CustomTabBarOrientation.horizontal
          ? EdgeInsets.only(
              top: padding10,
              bottom: padding10,
            )
          : EdgeInsets.only(
              left: padding10,
              right: padding10,
            );
    }
  }

  double? setHeight() {
    if (widget.orientation == CustomTabBarOrientation.horizontal) {
      return (widget.height ??
              ((widget.customTabBarItems.length) *
                      (padding10 + itemSize + padding20)) -
                  ((widget.customTabBarItems.length - 2) * 10))
          .toDouble();
    } else {
      return 57;
    }
  }

  double? setWith() {
    if (widget.orientation == CustomTabBarOrientation.vertical) {
      return (widget.width ??
              ((widget.customTabBarItems.length) *
                      (padding10 + itemSize + padding20)) -
                  ((widget.customTabBarItems.length - 2) * 10))
          .toDouble();
    } else {
      return 57;
    }
  }

  Widget setIcon(CustomTabBarItem item, bool itSelected) {
    Widget icon = Center(
      child: DecoratedIcon(
        item.icon ?? Icons.extension,
        color: Colors.lightBlue.shade50,
        shadows: [
          BoxShadow(
            blurRadius: 6.0,
            color: Colors.black,
            offset: Offset(0, 0.3),
          ),
        ],
      ),
    );
    return itSelected
        ? ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            ColorName.gradientColor1,
            ColorName.gradientColor2,
            ColorName.gradientColor3,
            ColorName.gradientColor2,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      child: icon,
    ) : icon;
  }

}

enum CustomTabBarOrientation { vertical, horizontal }

class CustomTabBarItem {
  final String? title;
  final IconData? icon;

  CustomTabBarItem({
    this.title,
    this.icon,
  });
}
