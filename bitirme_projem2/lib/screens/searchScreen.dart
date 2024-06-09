import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../bloc/client/client_cubit.dart';
import '../engine/localizations.dart';
import '../engine/storage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
                          SearchBox(),
                          TitleItem(AppLocalizations.of(context).getTranslate("search_title1")),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                MusicGenreFrame(
                                    "assets/images/searchMusic1.jpg", "#slow pop"),
                                MusicGenreFrame(
                                    "assets/images/searchMusic2.jpg", "#rock"),
                                MusicGenreFrame(
                                    "assets/images/searchMusic3.webp", "#rap"),
                                MusicGenreFrame(
                                    "assets/images/searchMusic4.jpg", "#jazz"),
                                Gap(14),
                              ],
                            ),
                          ),
                          TitleItem(AppLocalizations.of(context).getTranslate("search_title2")),
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
                              AllMusicGenreFrame("assets/images/searchGenre3.jpg", "Rock"),
                              AllMusicGenreFrame("assets/images/searchGenre4.jpg", "Metal"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AllMusicGenreFrame("assets/images/searchGenre5.jpg", "Jazz"),
                              AllMusicGenreFrame("assets/images/searchGenre6.jpg", "K-pop"),
                            ],
                          ),
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
        color: clientCubit.state.darkMode
                              ? Color.fromARGB(255, 245, 245, 247) : Color.fromARGB(255, 235, 235, 235),
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
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                hoverColor: Colors.transparent,
                isDense: true,
                hintText: AppLocalizations.of(context).getTranslate("search_searchMusic"),
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
          color: clientCubit.state.darkMode
                              ? Color.fromARGB(255, 240, 240, 240) : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
