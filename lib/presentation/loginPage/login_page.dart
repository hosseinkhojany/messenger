import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:telegram_flutter/common/router.dart';
import 'package:telegram_flutter/presentation/loginPage/ext.dart';
import '../../common/gen/colors.gen.dart';
import '../../domain/user/user_bloc.dart';
import '../chatPage/components/cutted_button.dart';
import '../chatPage/components/cutted_text_field.dart';
import '../globalWidgets/polygon/polygon_border.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditNameStater();
}

class EditNameStater extends State<LoginPage> {
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  final double textFieldHeight = 50;
  final double formSize = 350;
  bool createAccount = false;

  @override
  void dispose() {
    userNameEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          bool loading = false;
          if (state is UserLoginState) {
            loading = state.loading;
            if (state.success) {
              print("SUCCESS");
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushNamedAndRemoveUntil(
                    context, chatPageRoute, (_) => false);
              });
            }
          }
          return Scaffold(
            backgroundColor: ColorName.chatPageMainBackground,
            body: Stack(
              children: [
                Center(
                  child: Container(
                    width: formSize,
                    height: formSize,
                    decoration: ShapeDecoration(
                      shadows: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      color: ColorName.loginFormBackground,
                      shape: const PolygonBorder(
                        rotate: 90,
                        borderRadius: 12,
                        sides: 6,
                        side: BorderSide.none,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 75, right: 6, left: formSize / 2 - 30),
                          child: Text(
                            createAccount ? "Sign Up" : "Sign In",
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: (formSize - (textFieldHeight + 70)) / 2,
                              right: 50,
                              left: 80 / 2),
                          child: CutCornerTextField(
                            textInputAction: TextInputAction.next,
                            controller: userNameEditingController,
                            hintText: "username",
                            width: 200,
                            height: textFieldHeight,
                            leftIcon: Icons.person_pin,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: (formSize + textFieldHeight - 50) / 2,
                              right: 50,
                              left: 80 / 2),
                          child: CutCornerTextField(
                            textInputAction: TextInputAction.next,
                            isPassword: true,
                            controller: passwordEditingController,
                            hintText: "password",
                            width: 200,
                            height: textFieldHeight,
                            leftIcon: Icons.lock,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: ((formSize + textFieldHeight) / 2) +
                                  textFieldHeight -
                                  15,
                              right: 50,
                              left: 210 / 2),
                          child: CutCornerButton(
                            width: 90,
                            height: textFieldHeight,
                            text: createAccount ? "Create" : "LOGIN",
                            background: ColorName.chatPageMainBackground,
                            textStyle:
                                const TextStyle(color: Colors.white, fontSize: 20),
                            autoLoading: false,
                            loading: loading,
                            onClick: () {
                              sendImJoining();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: ((formSize + textFieldHeight) / 2) +
                                  textFieldHeight +
                                  15,
                              right: 50,
                              left: 110 / 2),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  createAccount = !createAccount;
                                });
                              },
                              child: Text(
                                createAccount
                                    ? "I have account"
                                    : "Create Account",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: formSize - 30),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: ColorName.topItemLoginFormBackground,
                        shape: const PolygonBorder(
                          rotate: 90,
                          borderRadius: 12,
                          sides: 6,
                          side: const BorderSide(color: Colors.white70, width: 3.0),
                        ),
                      ),
                      child: const Icon(Icons.verified_user),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onKey: (event) {
        if (event.logicalKey == LogicalKeyboardKey.enter && event.runtimeType == RawKeyUpEvent) {
          sendImJoining();
        }
      },
    );
  }

  void sendImJoining() {
    if (passwordEditingController.text.isNotEmpty &&
        userNameEditingController.text.isNotEmpty) {
      context.sendImJoined(createAccount, userNameEditingController.text,
          passwordEditingController.text);
    } else {
      Get.showSnackbar(const GetSnackBar(
        message: "do all fields fill",
      ));
    }
  }
}
