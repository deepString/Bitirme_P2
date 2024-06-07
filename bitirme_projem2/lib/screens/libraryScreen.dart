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

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
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
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(
            255, 30, 30, 30), // Color.fromARGB(255, 251, 251, 251),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Kitapliğin",
            style: TextStyle(
              color: Color.fromARGB(255, 240, 240, 240),
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 240, 240, 240),
          ),
          actions: [
            InkWell(
              onTap: () {},
              customBorder: CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  "assets/icons/search2.svg",
                  height: 21,
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(255, 240, 240, 240), BlendMode.srcIn),
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
                    size: 24, color: Color.fromARGB(255, 240, 240, 240)),
              ),
            ),
            Gap(10),
          ],
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
                      onTapRoute:
                          () {}, // Zaten kütüphane sayfasında olduğundan burası boş
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Gap(10),
                            CategoryItem("Oynatma listeleri"),
                            CategoryItem("Şarkilar"),
                            CategoryItem("Albümler"),
                            CategoryItem("Sanatçilar"),
                            CategoryItem("Podcast"),
                            Gap(18),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Son etkinlik",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 160, 160, 160),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Gap(5),
                                Icon(Icons.keyboard_arrow_down,
                                    size: 20,
                                    color: Color.fromARGB(255, 160, 160, 160)),
                              ],
                            ),
                            SvgPicture.asset(
                              "assets/icons/menu.svg",
                              height: 15,
                              colorFilter: ColorFilter.mode(
                                  Color.fromARGB(255, 160, 160, 160),
                                  BlendMode.srcIn),
                            ),
                          ],
                        ),
                      ),
                      LikedMusicPlaylist(size, "Beğendiğim müzikler"),
                      MusicPlaylist(size, "assets/images/playlistImage2.jpg", "Oturmaya mi geldik", "20"),
                      MusicPlaylist(size, "assets/images/playlistImage4.jpg", "Oynatma Listem 1", "15"),
                      MusicPlaylist(size, "assets/images/playlistImage5.jpg", "Oynatma Listem 2", "18"),
                      MusicPlaylist(size, "assets/images/playlistImage6.webp", "Oynatma Listem 3", "10"),
                      MusicPlaylist(size, "assets/images/playlistImage9.jpg", "Biraz da slow", "25"),
                      MusicPlaylist(size, "assets/images/playlistImage1.jpg", "Karişik", "16"),
                      MusicPlaylist(size, "assets/images/playlistImage3.jpg", "Rock", "13"),
                      MusicPlaylist(size, "assets/images/playlistImage4.jpg", "Jazz", "9"),
                      MusicPlaylist(size, "assets/images/playlistImage2.jpg", "Türkçe", "17"),
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

  Widget LikedMusicPlaylist(Size size, String title) {
    return Container(
      margin: EdgeInsets.only(left: 18),
      width: size.width - 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 201, 137, 198),
                      Color.fromARGB(255, 70, 92, 156),
                      Color.fromARGB(255, 6, 61, 57),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.thumb_up,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color.fromARGB(255, 240, 240, 240),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/pin.svg",
                        height: 12,
                        colorFilter: ColorFilter.mode(
                            Color.fromARGB(255, 150, 150, 150),
                            BlendMode.srcIn),
                      ),
                      Gap(5),
                      Text(
                        "Otomatik oynatma listesi",
                        style: TextStyle(
                          color: Color.fromARGB(255, 150, 150, 150),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.more_vert, color: Color.fromARGB(255, 240, 240, 240)),
        ],
      ),
    );
  }

  Widget MusicPlaylist(Size size, String photo, String title, String count) {
    return Container(
      margin: EdgeInsets.only(left: 18),
      width: size.width - 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(photo),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color.fromARGB(255, 240, 240, 240),
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    "Oynatma listesi • $count şarki",
                    style: TextStyle(
                      color: Color.fromARGB(255, 150, 150, 150),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.more_vert, color: Color.fromARGB(255, 240, 240, 240)),
        ],
      ),
    );
  }

  Widget CategoryItem(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      margin: EdgeInsets.only(left: 8, top: 8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 45, 45, 45),
        border: Border.all(
          color: Color.fromARGB(40, 255, 255, 255),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
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
            onTap: () => GoRouter.of(context).push("/search"),
            child: BottomMenuItems(
                "Ara", Icons.search_outlined, Icons.saved_search, false),
          ),
          InkWell(
            onTap:
                () {}, // Zaten kütüphane sayfasında olduğumuzdan Navigator eklemedim
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
