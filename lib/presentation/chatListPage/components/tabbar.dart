import 'package:flutter/material.dart';

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

  CustomTabBar({Key? key,
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
            children: createListTab(
                widget.orientation ?? CustomTabBarOrientation.vertical))
            : Row(
            children: createListTab(
                widget.orientation ?? CustomTabBarOrientation.vertical)),
      ),
    );
  }

  List<Widget> createListTab(CustomTabBarOrientation orientation) {
    List<Widget> tabs = [];
    for (int i = 0; i < widget.customTabBarItems.length; i++) {
      CustomTabBarItem item = widget.customTabBarItems[i];
      bool itSelected = widget._selected == i;
      Widget tab = InkWell(
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
                child: Icon(
                  item.icon,
                  color: widget.iconColor ?? Colors.black,
                ),
              ),
            ),
            // Container(
            //   width: 2,
            //   height: itemSize,
            //   decoration: BoxDecoration(
            //     color: itSelected ? Colors.black : Colors.transparent,
            //     borderRadius: BorderRadius.circular(99),
            //     gradient: itSelected
            //         ? LinearGradient(
            //       colors: [
            //         HexColor("#dd5d3e"),
            //         HexColor("#ec603e"),
            //       ],
            //       begin: Alignment(-1.0, -2.0),
            //       end: Alignment(1.0, 2.0),
            //     )
            //         : null,
            //   ),
            // ),
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
                      HexColor("#dd5d3e"),
                      HexColor("#ec603e"),
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

  EdgeInsets edgeInsetBannerColor(int index,
      CustomTabBarOrientation orientation) {
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
    return (widget.height ?? ((widget.customTabBarItems.length) *
        (padding10 + itemSize + padding20))-((widget.customTabBarItems.length-2)*10)).toDouble();
  }

  double? setWith() {
    return (widget.width ?? 57);
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
