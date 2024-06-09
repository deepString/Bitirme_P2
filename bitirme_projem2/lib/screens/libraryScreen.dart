import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../bloc/client/client_cubit.dart';
import '../engine/localizations.dart';
import '../engine/storage.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late ClientCubit clientCubit;

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
              backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 247, 241, 251))
            ),
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
              backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 247, 241, 251))
            ),
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
    var size = MediaQuery.of(context).size;

    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: clientCubit.state.darkMode
              ? Color.fromARGB(
                255, 30, 30, 30) : Color.fromARGB(255, 251, 251, 251),
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
                                CategoryItem(AppLocalizations.of(context).getTranslate("library_category1")),
                                CategoryItem(AppLocalizations.of(context).getTranslate("library_category2")),
                                CategoryItem(AppLocalizations.of(context).getTranslate("library_category3")),
                                CategoryItem(AppLocalizations.of(context).getTranslate("library_category4")),
                                CategoryItem(AppLocalizations.of(context).getTranslate("library_category5")),
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
                                      AppLocalizations.of(context).getTranslate("library_activity"),
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
              ],
            ),
          ),
        );
      }
    );
  }

  Widget LikedMusicPlaylist(Size size, String title) {
    return Container(
      margin: EdgeInsets.only(left: 18),
      width: size.width - 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => GoRouter.of(context).push("/favorite"),
            child: Row(
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
                        color: clientCubit.state.darkMode
                              ? Color.fromARGB(255, 240, 240, 240) : Colors.black87,
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
                          AppLocalizations.of(context).getTranslate("library_otoPlaylist"),
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
          ),
          Icon(Icons.more_vert, color: clientCubit.state.darkMode
                              ? Color.fromARGB(255, 240, 240, 240) : Colors.black87),
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
                      color: clientCubit.state.darkMode
                              ? Color.fromARGB(255, 240, 240, 240) : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).getTranslate("library_musicplaylist") + " • $count " + AppLocalizations.of(context).getTranslate("library_songCount"),
                    style: TextStyle(
                      color: Color.fromARGB(255, 150, 150, 150),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.more_vert, color: clientCubit.state.darkMode
                              ? Color.fromARGB(255, 240, 240, 240) : Colors.black87),
        ],
      ),
    );
  }

  Widget CategoryItem(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      margin: EdgeInsets.only(left: 8, top: 8),
      decoration: BoxDecoration(
        color: clientCubit.state.darkMode
                              ? Color.fromARGB(255, 45, 45, 45) : Color.fromARGB(255, 210, 210, 210),
        border: Border.all(
          color: Color.fromARGB(40, 255, 255, 255),
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          color: clientCubit.state.darkMode
                              ? Color.fromARGB(255, 240, 240, 240) : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
