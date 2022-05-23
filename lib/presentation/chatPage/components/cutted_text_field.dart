import 'package:flutter/material.dart';

class CutCornerTextField extends StatefulWidget {
  final double? height;
  final double? width;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final String? hintText;
  final TextEditingController? controller;
  final Function? icon2Click;
  final bool? isPassword;
  final TextInputAction? textInputAction;
  bool _showPassword = false;

  CutCornerTextField(
      {Key? key,
      this.height,
      this.width,
      this.leftIcon,
      this.rightIcon,
      this.hintText,
      this.controller,
      this.icon2Click,
      this.isPassword, this.textInputAction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CutCornerTextFieldStater();
  }
}

class _CutCornerTextFieldStater extends State<CutCornerTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          clipBehavior: Clip.antiAlias,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                  widget.height == null ? 20 : widget.height! + 20),
              bottomLeft: Radius.circular(
                  widget.height == null ? 20 : widget.height! + 20),
            ),
          ),
          child: Container(
            height: widget.height,
            width: widget.height == null ? 20 : (widget.height! + 10) / 2,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(widget.leftIcon),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    widget.height == null ? 20 : widget.height!),
                bottomLeft: Radius.circular(
                    widget.height == null ? 20 : widget.height!),
              ),
            ),
          ),
        ),
        Container(
            color: Colors.white,
            width: widget.width,
            height: widget.height,
            child: Row(
              children: [
                SizedBox(width: 6),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    width: 1,
                    height: widget.height,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(
                  width: widget.height == null
                      ? double.infinity
                      : (widget.width! - 10),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 4),
                    child: TextField(
                      obscureText: ((widget.isPassword ?? false) &&
                              widget._showPassword == false)
                          ? true
                          : false,
                      textInputAction: widget.textInputAction,
                      controller: widget.controller,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            )),
        Material(
          clipBehavior: Clip.antiAlias,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                  widget.height == null ? 20 : widget.height! + 20),
              bottomRight: Radius.circular(
                  widget.height == null ? 20 : widget.height! + 20),
            ),
          ),
          child: Container(
            height: widget.height,
            width: widget.height == null ? 20 : (widget.height! + 10) / 2,
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: MouseRegion(
                cursor: (widget.isPassword != null || widget.icon2Click != null) ? SystemMouseCursors.click : SystemMouseCursors.basic,
                child: GestureDetector(
                  onTap: () {
                    if (widget.icon2Click != null) {
                      widget.icon2Click?.call();
                    } else {
                      setState(() {
                        widget._showPassword = !widget._showPassword;
                      });
                    }
                  },
                  child: Icon(
                      (widget.isPassword == null)
                          ? widget.rightIcon
                          : (widget._showPassword)
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                      size: 20),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                    widget.height == null ? 20 : widget.height! + 20),
                bottomRight: Radius.circular(
                    widget.height == null ? 20 : widget.height! + 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
