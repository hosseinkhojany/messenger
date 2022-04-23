import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telegram_flutter/controller/chat_controller.dart';
import 'package:telegram_flutter/di/bindings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // home: _buildStack()
        // initialRoute: SPLASH_ROUTE,
        initialBinding: AppBindings(),
        // onGenerateRoute: router.generateRoute,
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController textEditingController = TextEditingController();
  ChatController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello"),
      ),
      body: StreamBuilder(
            stream: controller.chatStream(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: textEditingController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your username',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          controller.sendMessage(textEditingController.text);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
