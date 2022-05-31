import 'package:flutter/material.dart';

import '../../../common/gen/assets.gen.dart';
import '../../../common/gen/colors.gen.dart';
import '../../../data/models/chat.dart';

class ChatItem extends StatelessWidget {
  final ChatModel chatModel;
  const ChatItem({Key? key, required this.chatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (chatModel.runtimeType) {
      case PrivateChat:
        PrivateChat model = chatModel as PrivateChat;
        return Padding(
          padding: const EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: model.isActive
                    ? [
                        const BoxShadow(
                            offset: const Offset(0, 0.3),
                            color: Colors.black,
                            blurRadius: 5,
                            blurStyle: BlurStyle.solid),
                      ]
                    : null,
                color: const Color(0xFF1F2747),
                gradient: model.isActive
                    ? const LinearGradient(
                        colors: [
                          ColorName.gradientColor1,
                          ColorName.gradientColor3,
                          ColorName.gradientColor4,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: Assets.images.b.image().image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.username,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                model.lastMessage,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        model.time,
                        style: const TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (model.unreadCounts > 0)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text(model.unreadCounts.toString(),
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.white)),
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        );
      default:
        return const Text("handle other chat types");
    }
  }
}
