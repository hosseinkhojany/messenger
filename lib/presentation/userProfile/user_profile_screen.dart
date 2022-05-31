import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Container(
              width: width,
              height: height * 0.5,
              decoration: const BoxDecoration(
                color: Colors.amber,
                // todo This should give from user
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.jpeg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: height * 0.25,
              left: width * 0.15,
              child: SizedBox(
                width: width * 0.7,
                height: height * 0.6,
                child: const Card(
                  elevation: 15,
                  // color: Colors.green,
                ),
              ),
            ),
            Positioned(
              top: height * 0.12,
              left: width * 0.43,
              child: const SizedBox(
                width: 200,
                height: 200,
                child: CircleAvatar(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.red,
                    child: FlutterLogo(
                      size: 90,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: width * 0.04,
              top: height * 0.04,
              child: const InkWell(
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.amber,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: height * 0.32,
              left: width * 0.56,
              child: const InkWell(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.amber,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
