import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import '../engine/storage.dart';
import '../widgets/drawerItem.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(
            255, 30, 30, 30), // Color.fromARGB(255, 251, 251, 251),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Ara",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 234, 234, 234),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 251, 251, 251),
          surfaceTintColor: Color.fromARGB(255, 251, 251, 251),
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
                        color: Color.fromARGB(255, 132, 132, 132),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
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
                        color: Colors.black87,
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
                      name: "Oynatma Listeleri",
                      icon: Icon(Icons.library_music, size: 22),
                      onTapRoute: () {
                        GoRouter.of(context).push("/library");
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
                            "Bize Ulaşin",
                            style: TextStyle(
                              color: Colors.black87,
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
                      name: "Ayarlar",
                      icon: Icon(Icons.settings, size: 22),
                      onTapRoute: () {
                        GoRouter.of(context).push("/setting");
                      },
                    ),
                    Divider(
                      color: Color.fromARGB(136, 155, 155, 155),
                    ),
                    DrawerItem(
                      name: "Oturumu kapat",
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
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchBox(),
                      TitleItem("Müzik türlerini keşfet"),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            MusicGenreFrame(
                                "assets/images/searchMusic1.jpg", "#slow pop"),
                            MusicGenreFrame(
                                "assets/images/searchMusic2.avif", "#rock"),
                            MusicGenreFrame(
                                "assets/images/searchMusic3.webp", "#rap"),
                            MusicGenreFrame(
                                "assets/images/searchMusic4.jpg", "#jazz"),
                            Gap(14),
                          ],
                        ),
                      ),
                      TitleItem("Hepsine göz at"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AllMusicGenreFrame("assets/images/searchGenre1.jpg", "Podcasts"),
                          AllMusicGenreFrame("assets/images/searchGenre2.jpg", "Pop"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AllMusicGenreFrame("assets/images/searchGenre3.avif", "Rock"),
                          AllMusicGenreFrame("assets/images/searchGenre4.jpg", "Metal"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AllMusicGenreFrame("assets/images/searchGenre5.jpg", "Jazz"),
                          AllMusicGenreFrame("assets/images/searchGenre6.avif", "K-pop"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomMenu(),
          ],
        ),
      ),
    );
  }

  Widget AllMusicGenreFrame(String photo, String genre) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 15, top: 2, bottom: 20),
      width: 160,
      height: 170,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(photo),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
            bottomRight: Radius.circular(40)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(60, 0, 0, 0),
              Color.fromARGB(60, 0, 0, 0),
              Color.fromARGB(150, 0, 0, 0),
            ],
          ),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                genre,
                style: TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 240, 240, 240),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Gap(8),
          ],
        ),
      ),
    );
  }

  Widget MusicGenreFrame(String photo, String genre) {
    return Container(
      margin: const EdgeInsets.only(left: 14, top: 2),
      width: 100,
      height: 160,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(photo),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(80, 0, 0, 0),
              Color.fromARGB(80, 0, 0, 0),
              Color.fromARGB(130, 0, 0, 0),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              genre,
              style: TextStyle(
                fontSize: 13,
                color: Color.fromARGB(255, 240, 240, 240),
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(8),
          ],
        ),
      ),
    );
  }

  Widget SearchBox() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      padding: EdgeInsets.only(left: 15, right: 10),
      height: 45,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 245, 245, 247),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/search2.svg",
            height: 21,
            colorFilter: ColorFilter.mode(Colors.black87, BlendMode.srcIn),
          ),
          Expanded(
            child: TextField(
              cursorColor: Color.fromARGB(255, 113, 113, 113),
              decoration: InputDecoration(
                isDense: true,
                hintText: "Şarki ara",
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 75, 75, 75),
                  fontSize: 15,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget TitleItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 240, 240, 240),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget BottomMenu() {
    return Container(
      color: Color.fromARGB(255, 40, 40, 40),
      width: double.infinity,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: () => GoRouter.of(context).push("/home"),
            child: BottomMenuItems(
                "Ana Sayfa", Icons.home_outlined, Icons.home, true),
          ),
          InkWell(
            onTap:
                () {}, // Zaten arama sayfasında olduğumuzdan Navigator eklemedim
            child: BottomMenuItems(
                "Ara", Icons.search_outlined, Icons.saved_search, false),
          ),
          InkWell(
            onTap: () => GoRouter.of(context).push("/library"),
            child: BottomMenuItems("Kitapliğin", Icons.library_music_outlined,
                Icons.library_music, false),
          ),
          InkWell(
            onTap: () => GoRouter.of(context).push("/profile"),
            child: BottomMenuItems(
                "Profil", Icons.person_outline, Icons.person, false),
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
            color: Color.fromARGB(255, 234, 234, 234),
          ),
          SizedBox(height: 2),
          Text(
            iconName,
            style: TextStyle(
              fontSize: 10,
              color: Color.fromARGB(255, 234, 234, 234),
            ),
          ),
        ],
      ),
    );
  }
}
