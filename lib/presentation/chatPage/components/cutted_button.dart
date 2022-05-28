import 'package:flutter/material.dart';

class CutCornerButton extends StatefulWidget {
  final double? height;
  final double? width;
  final String? text;
  final Color? background;
  final TextStyle? textStyle;
  final Function? onClick;
  bool? loading;
  final bool? autoLoading;

  CutCornerButton({Key? key,
    this.height,
    this.width,
    this.text,
    this.background,
    this.textStyle,
    this.onClick,
    this.loading, this.autoLoading})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CutCornerButtonStater();
  }
}

class _CutCornerButtonStater extends State<CutCornerButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.autoLoading ?? false){
          widget.loading = true;
        }
        widget.onClick?.call();
        setState(() {});
      },
      child: SizedBox(
        width: widget.width! + (widget.height!) / 2 + (widget.height!) / 2,
        child: Row(
          children: [
            Material(
              color: widget.background,
              clipBehavior: Clip.antiAlias,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      widget.height == null ? 20 : widget.height!),
                  bottomLeft: Radius.circular(
                      widget.height == null ? 20 : widget.height!),
                ),
              ),
              child: Container(
                height: widget.height,
                width: widget.height == null ? 20 : (widget.height!) / 2,
                decoration: BoxDecoration(
                  color: widget.background,
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
              width: widget.width,
              height: widget.height,
              color: widget.background,
              child: SizedBox(
                width:
                widget.height == null ? double.infinity : (widget.width! - 10),
                child: Center(
                  child: (widget.loading ?? false) ?
                      Container(
                        width: 25,
                        height: 25,
                        child:
                        CircularProgressIndicator(
                          backgroundColor: Colors.lightBlueAccent,
                        ) ,
                      ) : Text(widget.text ?? "", style: widget.textStyle,)
                ),
              ),
            ),
            Material(
              color: widget.background,
              clipBehavior: Clip.antiAlias,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                      widget.height == null ? 20 : widget.height!),
                  bottomRight: Radius.circular(
                      widget.height == null ? 20 : widget.height!),
                ),
              ),
              child: Container(
                height: widget.height,
                width: widget.height == null ? 20 : (widget.height!) / 2,
                decoration: BoxDecoration(
                  color: widget.background,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                        widget.height == null ? 20 : widget.height!),
                    bottomRight: Radius.circular(
                        widget.height == null ? 20 : widget.height!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ) ,
    );
  }
}