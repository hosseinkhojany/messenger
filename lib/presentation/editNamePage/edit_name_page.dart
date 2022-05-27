import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:telegram_flutter/app/router.dart';
import 'package:telegram_flutter/gen/colors.gen.dart';
import 'package:telegram_flutter/presentation/editNamePage/ext.dart';
import '../chatPage/components/cutted_button.dart';
import '../chatPage/components/cutted_text_field.dart';
import '../globalWidgets/customDialog/app_dialogs.dart';
import '../globalWidgets/polygon/polygon_border.dart';
import '../sharedBloc/socket/socket_bloc.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditNameStater();
}

class EditNameStater extends State<EditNamePage> {
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
      child: BlocBuilder<SocketBloc, SocketState>(
        builder: (context, state) {
          bool loading = false;
          if (state is UserJoinedState) {
            loading = state.loading;
            if (state.success) {
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushNamedAndRemoveUntil(
                    context, CHAT_PAGE, (_) => false);
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 75, right: 6, left: formSize / 2 - 30),
                          child: Text(
                            createAccount ? "Sign Up" : "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
                                TextStyle(color: Colors.white, fontSize: 20),
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
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  createAccount = !createAccount;
                                });
                              },
                              child: Text(
                                createAccount
                                    ? "I have account"
                                    : "Create Account",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    decoration: ShapeDecoration(
                      shadows: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                      ],
                      color: ColorName.loginFormBackground,
                      shape: PolygonBorder(
                        rotate: 90,
                        borderRadius: 12,
                        sides: 6,
                        side: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: formSize - 30),
                    child: Container(
                      child: Icon(Icons.verified_user),
                      width: 90,
                      height: 90,
                      decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                        color: ColorName.topItemLoginFormBackground,
                        shape: PolygonBorder(
                          rotate: 90,
                          borderRadius: 12,
                          sides: 6,
                          side: BorderSide(color: Colors.white70, width: 3.0),
                        ),
                      ),
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
    if (passwordEditingController.text.length > 0 &&
        userNameEditingController.text.length > 0) {
      context.sendImJoined(createAccount, userNameEditingController.text,
          passwordEditingController.text);
    } else {
      Get.showSnackbar(GetSnackBar(
        message: "do all fields fill",
      ));
    }
  }
}
