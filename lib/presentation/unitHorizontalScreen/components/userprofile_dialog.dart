import 'package:flutter/material.dart';
import 'package:telegram_flutter/gen/colors.gen.dart';

class UserDialog extends StatelessWidget {
  const UserDialog({Key? key, required this.height, required this.width})
      : super(key: key);
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black45,
      elevation: 25,
      child: Container(
        color: ColorName.chatPageMainBackground,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        width: width * 0.27,
        height: height * 0.85,
        child: Column(
          children: [
            // header of dialog
            SizedBox(
              width: width,
              height: height * 0.05,
              // color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const SizedBox(width: 10),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            // profile Section
            SizedBox(
              // color: Colors.greenAccent,
              width: width,
              height: height * 0.10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // user profile
                  const CircleAvatar(
                    radius: 40,
                    child: FlutterLogo(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        // User name
                        Text(
                          'abolfazl',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Lat seeen
                        Text(
                          'Last seen at 9:36 AM',
                          style: TextStyle(
                            color: Colors.white,
                            // fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),

            // divider

            Container(
              width: width,
              height: 10,
              color: const Color.fromARGB(255, 121, 142, 213),
            ),
            const SizedBox(
              height: 15,
            ),
            // menu Options
            SizedBox(
              // color: Colors.greenAccent,
              width: width,
              height: height * 0.38,
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Notification and Sound',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Privacy and Security',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.chat_bubble_outline_outlined,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Chat Settings',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.folder_open_outlined,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Folders',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.settings_rounded,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Advanced',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.translate,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Languages',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),

            // divider

            Container(
              width: width,
              height: 10,
              color: const Color.fromARGB(255, 121, 142, 213),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
