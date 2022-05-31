import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telegram_flutter/common/utils/ext.dart';
import 'package:telegram_flutter/presentation/chatListPage/chat_list_page.dart';
import 'package:telegram_flutter/presentation/chatPage/chat_page.dart';

import '../../common/gen/assets.gen.dart';
import '../../common/gen/colors.gen.dart';
import '../globalWidgets/advanceDrawerMenu/src/controller.dart';
import '../globalWidgets/advanceDrawerMenu/src/widget.dart';

class MergedChatListChatPageScreen extends StatefulWidget {
  MergedChatListChatPageScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MergedChatListChatPageScreenState();
  }
}

class MergedChatListChatPageScreenState
    extends State<MergedChatListChatPageScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  bool isHaveOpeningChat = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdvancedDrawer(
        backdropColor: ColorName.sideMenuBackground,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        // openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: const DrawerMenuItems(),
        child: responsiveChooser(),
      ),
    );
  }

  Widget responsiveChooser() {
    Widget widget = Container();
    if (context.isHorizontalScreen()) {
      //use horizontal |
      if (isHaveOpeningChat) {
        //open fullscreen chat page
        widget = ChatListPage(
          onMenuClicked: () {
            _advancedDrawerController.showDrawer();
          },
        );
      } else {
        //open fullscreen chat list page
        widget = const ChatPage();
      }
    } else {
      widget = Row(children: [
        Expanded(child: ChatListPage(
          onMenuClicked: () {
            _advancedDrawerController.showDrawer();
          },
        )),
        const Expanded(child: ChatPage())
      ]);
    }
    return widget;
  }
}

class DrawerMenuItems extends StatefulWidget {
  const DrawerMenuItems({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DrawerMenuItemsState();
  }
}

class DrawerMenuItemsState extends State<DrawerMenuItems>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.slowMiddle,
  );

  bool showProfileEdit = false;
  bool showProfileEditCurrentHover = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // USER AVATAR -------------------
            Container(
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 64.0,
              ),
              width: 128.0,
              height: 128.0,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {},
                        onHover: (value) {
                          showProfileEditCurrentHover = value;
                          if (value) {
                            if (!showProfileEdit) {
                              setState(() {
                                showProfileEdit = true;
                                _controller.reset();
                                _controller.animateTo(1);
                              });
                            }
                          } else {
                            Future.delayed(Duration(milliseconds: 300), () {
                              if (showProfileEdit &&
                                  !showProfileEditCurrentHover) {
                                setState(() {
                                  showProfileEdit = false;
                                  _controller.reset();
                                  _controller.animateTo(1);
                                });
                              }
                            });
                          }
                        },
                        child: Image.asset(
                          'assets/images/b.png',
                        ),
                      ),
                    ),
                  ),
                  if (showProfileEdit)
                    ScaleTransition(
                      alignment: Alignment.center,
                      scale: _animation,
                      child: InkWell(
                        onTap: () {},
                        onHover: (value) {
                          showProfileEditCurrentHover = value;
                          if (value) {
                            showProfileEdit = true;
                          } else {
                            Future.delayed(Duration(milliseconds: 300), () {
                              if (!showProfileEditCurrentHover) {
                                setState(() {
                                  showProfileEdit = false;
                                  _controller.reset();
                                  _controller.animateTo(0);
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 14.0,
                            left: 14.0,
                          ),
                          child: PopupMenuButton(
                            tooltip: "Edit profile",
                            child: Icon(Icons.edit),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem<String>(
                                    child: Row(
                                        children: [
                                          Text('Camera'),
                                          Icon(Icons.camera_alt_rounded, size: 24)
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween),
                                    value: '1'),
                                PopupMenuItem<String>(
                                    child: Row(
                                        children: [
                                          Text('Files'),
                                          Icon(Icons.browse_gallery_rounded, size: 24)
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween),
                                    value: '2'),
                                PopupMenuItem<String>(
                                    child: Row(
                                        children: [
                                          Text('Pokemons'),
                                          Assets.images.pokemonIcons.image(height: 24, width: 24)
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween),
                                    value: '3'),
                              ];
                            },
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),

            // MENU ITEMS --------------------

            ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: Text("Accounts"),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text("Contacts"),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text("Settings"),
            ),
            const Spacer(),
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: Text('Terms of Service | Privacy Policy'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
