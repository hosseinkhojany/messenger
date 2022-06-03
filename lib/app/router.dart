import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:telegram_flutter/presentation/editNamePage/edit_name_page.dart';
import 'package:telegram_flutter/presentation/unitHorizontalScreen/horizontal_merged_chatlist_chatpage_screen.dart';
import 'package:telegram_flutter/presentation/userProfile/user_profile_screen.dart';

const String EDIT_NAME_PAGE = "/editName";
const String CHAT_PAGE = "/chat";

class AppRouter {
  static SharedAxisTransition globalTransaction(
      context, animation, secondaryAnimation, child) {
    return SharedAxisTransition(
      fillColor: Colors.black,
      transitionType: SharedAxisTransitionType.scaled,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case EDIT_NAME_PAGE:
        // return PageTransition(child: SplashScreen(), type: PUSH_ANIMATION);
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const EditNamePage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return globalTransaction(
                context, animation, secondaryAnimation, child);
          },
        );
      case CHAT_PAGE:
        // return PageTransition(child: SignUpScreen(), type: PUSH_ANIMATION);
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const MergedChatListChatPageScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return globalTransaction(
                context, animation, secondaryAnimation, child);
          },
        );
      default:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const EditNamePage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return globalTransaction(
                context, animation, secondaryAnimation, child);
          },
        );
    }
  }
}
