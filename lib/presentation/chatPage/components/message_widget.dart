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
    return Row(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Icon(Icons.message),
        ),
        Expanded(
          child: Card(
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(widget.message.message ?? ""),
              ),
            ),
          ),
        )
      ],
    );
  }
}
