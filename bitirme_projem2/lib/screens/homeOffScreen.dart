import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import '../bloc/client/client_cubit.dart';
import '../engine/localizations.dart';
import '../engine/storage.dart';
import '../widgets/drawerItem.dart';

class HomeOffScreen extends StatefulWidget {
  final Widget child;
  final GoRouterState state;
  const HomeOffScreen({super.key, required this.child, required this.state});

  @override
  State<HomeOffScreen> createState() => _HomeOffScreenState();
}

class _HomeOffScreenState extends State<HomeOffScreen> {
  late ClientCubit clientCubit;

  bool isProfile = false;

  Map<String, dynamic> userInfo = {
    "Id": "",
    "Name": "",
  };

  checkLogin() async {
    Storage storage = Storage();

    final user = await storage.loadUser();

    if (user == null) {
      GoRouter.of(context).replace("/login");
    } else {
      setState(() {
        userInfo = user;
      });
    }
  }

  logoutMaterial() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning,
              size: 30,
              color: Colors.red.shade300,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              "Çikişi Onayla",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 25,
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 239, 230, 248),
        content: Text(
          "Çikiş yapmak istediğine emin misin?",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Storage storage = Storage();
              await storage.clearUser();
              GoRouter.of(context).replace("/welcome");
              GoRouter.of(context).pop();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(255, 247, 241, 251))),
            child: Text(
              "Onayla",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () => GoRouter.of(context).pop(),
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 247, 241, 251))),
              child: Text(
                "İptal",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
              )),
        ],
      ),
    );
  }

  logoutIOS() async {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning,
              size: 30,
              color: Colors.red.shade300,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              "Çikişi Onayla",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Text(
          "Çikiş yapmak istediğine emin misin?",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () async {
              Storage storage = Storage();
              await storage.clearUser();
              GoRouter.of(context).replace("/welcome");
            },
            child: Text(
              "Onayla",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            isDestructiveAction: true,
          ),
          CupertinoDialogAction(
            onPressed: () => GoRouter.of(context).pop(),
            child: Text(
              "İptal",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
    clientCubit = context.read<ClientCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: clientCubit.state.darkMode
              ? isProfile
                  ? Color.fromARGB(255, 40, 32, 25)
                  : Color.fromARGB(255, 30, 30, 30)
              : Color.fromARGB(255, 251, 251, 251),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                if (widget.state.fullPath == "/search")
                  Text(
                    AppLocalizations.of(context).getTranslate("search_appbar"),
                    style: TextStyle(
                      color: clientCubit.state.darkMode
                          ? Colors.white
                          : Colors.black87,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else if (widget.state.fullPath == "/library")
                  Text(
                    AppLocalizations.of(context).getTranslate("library_appbar"),
                    style: TextStyle(
                      color: clientCubit.state.darkMode
                          ? Color.fromARGB(255, 240, 240, 240)
                          : Colors.black87,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else if (widget.state.fullPath == "/profile")
                  Text(
                    "@berkayt",
                    style: TextStyle(
                        color: clientCubit.state.darkMode
                            ? Color.fromARGB(255, 225, 224, 223)
                            : Colors.black87),
                  ),
              ],
            ),
            toolbarHeight: 65,
            iconTheme: IconThemeData(
              color: clientCubit.state.darkMode
                  ? Color.fromARGB(255, 220, 220, 220)
                  : Colors.black87,
            ),
            actions: [
              if (widget.state.fullPath == "/home")
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          "assets/icons/podcasts.svg",
                          height: 21,
                          colorFilter: ColorFilter.mode(
                              clientCubit.state.darkMode
                                  ? Color.fromARGB(255, 234, 234, 234)
                                  : Colors.black87,
                              BlendMode.srcIn),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          "assets/icons/notification.svg",
                          height: 21,
                          colorFilter: ColorFilter.mode(
                              clientCubit.state.darkMode
                                  ? Color.fromARGB(255, 234, 234, 234)
                                  : Colors.black87,
                              BlendMode.srcIn),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              else if (widget.state.fullPath == "/library")
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      customBorder: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          "assets/icons/search2.svg",
                          height: 21,
                          colorFilter: ColorFilter.mode(
                              clientCubit.state.darkMode
                                  ? Color.fromARGB(255, 240, 240, 240)
                                  : Colors.black87,
                              BlendMode.srcIn),
                        ),
                      ),
                    ),
                    Gap(2),
                    InkWell(
                      onTap: () {},
                      customBorder: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.add,
                            size: 24,
                            color: clientCubit.state.darkMode
                                ? Color.fromARGB(255, 240, 240, 240)
                                : Colors.black87),
                      ),
                    ),
                    Gap(10),
                  ],
                )
              else if (widget.state.fullPath == "/profile")
                Row(
                  children: [
                    Container(
                      height: 20,
                      child: Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: clientCubit.state.darkMode,
                          onChanged: (value) {
                            setState(() {
                              clientCubit.changeDarkMode(darkMode: value);
                            });
                          },
                          activeThumbImage:
                              AssetImage("assets/images/nightMode.png"),
                          inactiveThumbImage:
                              AssetImage("assets/images/lightMode.png"),
                          activeTrackColor: Colors.white,
                          trackOutlineColor: MaterialStatePropertyAll(
                              clientCubit.state.darkMode
                                  ? Color.fromARGB(255, 185, 185, 185)
                                  : Colors.grey),
                          thumbColor: MaterialStatePropertyAll(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          drawer: Drawer(
            backgroundColor: clientCubit.state.darkMode
                ? isProfile
                    ? Color.fromARGB(255, 40, 32, 25)
                    : Color.fromARGB(255, 30, 30, 30)
                : Color.fromARGB(255, 251, 251, 251),
            surfaceTintColor: clientCubit.state.darkMode
                ? Color.fromARGB(255, 30, 30, 30)
                : Color.fromARGB(255, 251, 251, 251),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      right: 6, left: 6, top: 50, bottom: 30),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: clientCubit.state.darkMode
                              ? Color.fromARGB(255, 240, 135, 64)
                              : Color.fromARGB(255, 132, 132, 132),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: clientCubit.state.darkMode
                                ? Color.fromARGB(255, 30, 30, 30)
                                : Colors.white,
                          ),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/profil1.jpg"),
                            radius: 40,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${userInfo["Name"]}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Divider(
                        color: Color.fromARGB(136, 155, 155, 155),
                      ),
                      DrawerItem(
                        name: AppLocalizations.of(context)
                            .getTranslate("drawer_playlists"),
                        icon: Icon(Icons.library_music, size: 22),
                        onTapRoute: () {
                          GoRouter.of(context).push("/library");
                        },
                      ),
                      DrawerItem(
                        name: AppLocalizations.of(context)
                            .getTranslate("drawer_findMusic"),
                        icon: Icon(Icons.graphic_eq, size: 22),
                        onTapRoute: () {
                          GoRouter.of(context).push("/musicRecognize");
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 15),
                        child: Row(
                          children: [
                            Icon(Icons.message, size: 22),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .getTranslate("drawer_contact"),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                final Uri uri =
                                    Uri.parse("https://github.com/deepString");
                                launchUrl(uri);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: SvgPicture.asset(
                                  "assets/icons/github.svg",
                                  height: 30,
                                  colorFilter: ColorFilter.mode(
                                      clientCubit.state.darkMode
                                          ? Colors.white
                                          : Colors.black87,
                                      BlendMode.srcIn),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                final Uri uri = Uri.parse("tel:+901234567899");
                                launchUrl(uri);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(Icons.phone),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DrawerItem(
                        name: AppLocalizations.of(context)
                            .getTranslate("drawer_settings"),
                        icon: Icon(Icons.settings, size: 22),
                        onTapRoute: () {
                          GoRouter.of(context).push("/setting");
                        },
                      ),
                      Divider(
                        color: Color.fromARGB(136, 155, 155, 155),
                      ),
                      DrawerItem(
                        name: AppLocalizations.of(context)
                            .getTranslate("drawer_signOut"),
                        icon: Icon(Icons.logout_outlined, size: 22),
                        onTapRoute: () {
                          if (kIsWeb) {
                            logoutMaterial();
                          } else {
                            if (Platform.isIOS || Platform.isMacOS) {
                              logoutIOS();
                            } else {
                              logoutMaterial();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Text(
                  "Version 1.0.0",
                  style: TextStyle(
                      color: clientCubit.state.darkMode
                          ? Color.fromARGB(200, 255, 255, 255)
                          : Colors.grey,
                      fontSize: 11),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          body: SizedBox.expand(
            child: widget.child,
          ),
          bottomNavigationBar: BottomMenu(widget.state.fullPath ?? ''),
        ),
      );
    });
  }

  Widget BottomMenu(final String currentPath) {
    return Container(
      color: clientCubit.state.darkMode
          ? isProfile
              ? Color.fromARGB(255, 35, 28, 21)
              : Color.fromARGB(255, 40, 40, 40)
          : Colors.white,
      width: double.infinity,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () {
              GoRouter.of(context).push("/home");
              isProfile = false;
            },
            child: BottomMenuItems(
                AppLocalizations.of(context).getTranslate("bottomItem_home"),
                Icons.home_outlined,
                Icons.home,
                currentPath == "/home" ? true : false),
          ),
          InkWell(
            onTap: () {
              GoRouter.of(context).push("/search");
              isProfile = false;
            },
            child: BottomMenuItems(
                AppLocalizations.of(context).getTranslate("bottomItem_search"),
                Icons.search_outlined,
                Icons.saved_search,
                currentPath == "/search" ? true : false),
          ),
          InkWell(
            onTap: () {
              GoRouter.of(context).push("/library");
              isProfile = false;
            },
            child: BottomMenuItems(
                AppLocalizations.of(context).getTranslate("bottomItem_library"),
                Icons.library_music_outlined,
                Icons.library_music,
                currentPath == "/library" ? true : false),
          ),
          InkWell(
            onTap: () {
              GoRouter.of(context).push("/profile");
              isProfile = true;
            },
            child: BottomMenuItems(
                AppLocalizations.of(context).getTranslate("bottomItem_profile"),
                Icons.person_outline,
                Icons.person,
                currentPath == "/profile" ? true : false),
          ),
        ],
      ),
    );
  }

  Widget BottomMenuItems(String iconName, IconData iconActive,
      IconData iconDeactive, bool active) {
    IconData changeIcon = active ? iconDeactive : iconActive;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            changeIcon,
            size: 26,
            color: clientCubit.state.darkMode
                ? Color.fromARGB(255, 234, 234, 234)
                : Colors.black87,
          ),
          SizedBox(height: 2),
          Text(
            iconName,
            style: TextStyle(
              fontSize: 10,
              color: clientCubit.state.darkMode
                  ? Color.fromARGB(255, 234, 234, 234)
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
