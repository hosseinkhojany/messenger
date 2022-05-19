import 'package:flutter/material.dart';
import 'package:telegram_flutter/core/data/models/message.dart';

class UserJoinedLeftWidget extends StatefulWidget {
  final UserLeft? left;
  final UserJoined? joined;

  const UserJoinedLeftWidget({
    Key? key,
    this.left,
    this.joined,
  }) : super(key: key);

  @override
  _UserJoinedLeftWidgetStater createState() => _UserJoinedLeftWidgetStater();
}

class _UserJoinedLeftWidgetStater extends State<UserJoinedLeftWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(
                  Radius.circular(999),
                ),
                color: getColor(),
                boxShadow: [
                  BoxShadow(
                      color: getColor(),
                      spreadRadius: 2,
                      blurRadius: 10,
                      blurStyle: BlurStyle.normal),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(getUserName()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor() {
    Color result = Colors.green;
    if (widget.left != null) {
      result = Colors.redAccent;
    }
    return result;
  }

  String getUserName() {
    String result = "";
    if (widget.joined != null) {
      result = (widget.joined!.my ? "You" :(widget.joined?.userName ?? "")) + " Joined";
    } else {
      result = (widget.left!.my ? "You" :(widget.left?.userName ?? "")) + " Left";
    }
    return result;
  }
}
