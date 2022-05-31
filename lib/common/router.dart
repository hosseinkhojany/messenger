import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:telegram_flutter/presentation/introScreen/intro_screen.dart';
import 'package:telegram_flutter/presentation/loginPage/login_page.dart';
import 'package:telegram_flutter/presentation/unitHorizontalScreen/horizontal_merged_chatlist_chatpage_screen.dart';


const String loginRoute = "/login";
const String chatPageRoute = "/chat";
const String introRoute = "/introPage";

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
      case loginRoute:
        // return PageTransition(child: SplashScreen(), type: PUSH_ANIMATION);
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const LoginPage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return globalTransaction(
                context, animation, secondaryAnimation, child);
          },
        );
      case chatPageRoute:
        // return PageTransition(child: SignUpScreen(), type: PUSH_ANIMATION);
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return MergedChatListChatPageScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return globalTransaction(
                context, animation, secondaryAnimation, child);
          },
        );
      case introRoute:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const IntroScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return globalTransaction(
                context, animation, secondaryAnimation, child);
          },
        );
      default:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const LoginPage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return globalTransaction(
                context, animation, secondaryAnimation, child);
          },
        );
    }
  }
}
