import 'package:flutter/material.dart';
import 'package:telegram_flutter/core/data/models/message.dart';
import 'package:telegram_flutter/core/utils/ext.dart';

class MessageWidget extends StatefulWidget {
  double width = 0, height = 60;

  final Message message;

  MessageWidget(
      {Key? key,
      required this.width,
      required this.height,
      required this.message})
      : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MessageWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.width == 0) {
      widget.width = MediaQuery.of(context).size.width;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.message.my ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: <Widget>[
            Container(
              height: widget.height,
              width: widget.width,
              color: Colors.pinkAccent,
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: "#FAFAFA".toColor(),
                borderRadius: widget.message.my
                    ? BorderRadius.only(
                  bottomRight: Radius.circular(widget.height / 2),
                )
                    : BorderRadius.only(
                  bottomLeft: Radius.circular(widget.height / 2),
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: widget.message.my
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: widget.height,
                        height: widget.height,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: ExactAssetImage(""),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: widget.message.my
                          ? const EdgeInsets.only(right: 70)
                          : const EdgeInsets.only(left: 70),
                      child: Align(
                        alignment: widget.message.my
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          widget.message.my
                              ? "You"
                              : widget.message.userName ?? "",
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: widget.width,
              child: Material(
                color: Colors.pinkAccent,
                borderRadius: widget.message.my
                    ? BorderRadius.only(
                  bottomLeft: Radius.circular(widget.height / 3),
                  bottomRight: Radius.circular(widget.height / 3),
                  topLeft: Radius.circular(widget.height / 3),
                )
                    : BorderRadius.only(
                  bottomLeft: Radius.circular(widget.height / 3),
                  bottomRight: Radius.circular(widget.height / 3),
                  topRight: Radius.circular(widget.height / 3),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.message.message ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
