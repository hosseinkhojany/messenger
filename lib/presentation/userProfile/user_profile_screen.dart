import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return _mobileUi();
    }
    if (defaultTargetPlatform == TargetPlatform.fuchsia ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        kIsWeb) {
      return _desktopAndWebUi(height: height, width: width);
    }
    return const Scaffold();
  }

// todo Imprlmrnt the mobile Ui design
  _mobileUi() {
    return const Scaffold();
  }

  _desktopAndWebUi({required double width, required double height}) {
    return Scaffold(
      backgroundColor: Colors.white70.withOpacity(0.9),
      body: Center(
        child: SizedBox(
          width: width * 0.9,
          height: height * 0.9,
          child: Card(
            elevation: 15,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // LEFT CARD
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const CircleAvatar(
                          radius: 70,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            color: Colors.green,
                            child: Column(
                              children: [
                                
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // right Card
                Expanded(
                  child: Container(color: Colors.red),
                )
              ],
            ),
            // color: Colors.red,
          ),
        ),
      ),
    );
  }
}
