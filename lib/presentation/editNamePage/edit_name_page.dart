import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telegram_flutter/app/router.dart';
import 'package:telegram_flutter/core/controller/chat_controller.dart';

import '../../core/data/datasources/local/sharedStore.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditNameStater();
}

class EditNameStater extends State<EditNamePage> {
  TextEditingController textEditingController = TextEditingController();
  ChatController chatController = Get.find<ChatController>();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(SharedStore.getUserName().isNotEmpty){
      Navigator.pushNamed(context, CHAT_PAGE);
    }
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 300,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter your username',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: MaterialButton(
                    onPressed: () {
                      if(textEditingController.text.isNotEmpty){
                        chatController.userName = textEditingController.text.toString();
                        chatController.sendImJoined();
                        Navigator.pushNamed(context, CHAT_PAGE);
                      }else{
                        Get.snackbar("Error", "Enter a name");
                      }
                    },
                    elevation: 5,
                    textColor: Colors.black,
                    animationDuration: Duration(seconds: 2),
                    highlightElevation: 5,
                    child: Text("Let's go"),
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
        ),
      ),
    );
  }
}
