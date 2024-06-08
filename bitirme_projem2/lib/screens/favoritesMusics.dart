import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../bloc/client/client_cubit.dart';
import '../bloc/favorites/favorites_cubit.dart';
import '../engine/localizations.dart';

class FavoritesMusicsScreen extends StatefulWidget {
  const FavoritesMusicsScreen({super.key});

  @override
  State<FavoritesMusicsScreen> createState() => _FavoritesMusicsScreenState();
}

class _FavoritesMusicsScreenState extends State<FavoritesMusicsScreen> {
  late FavoritesCubit favoritesCubit;
  late ClientCubit clientCubit;

  @override
  void initState() {
    super.initState();
    favoritesCubit = context.read<FavoritesCubit>();
    clientCubit = context.read<ClientCubit>();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: clientCubit.state.darkMode
              ? Color.fromARGB(255, 30, 30, 30)
              : Color.fromARGB(255, 251, 251, 251),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: clientCubit.state.darkMode
                  ? Color.fromARGB(255, 234, 234, 234)
                  : Colors.black87,
            ),
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).getTranslate("favorites_title"),
                          style: TextStyle(
                            color: clientCubit.state.darkMode
                                ? Color.fromARGB(255, 234, 234, 234)
                                : Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SvgPicture.asset(
                          "assets/icons/search2.svg",
                          height: 21,
                          colorFilter: ColorFilter.mode(
                              clientCubit.state.darkMode
                                  ? Color.fromARGB(255, 234, 234, 234)
                                  : Colors.black87,
                              BlendMode.srcIn),
                        ),
                      ],
                    ),
                    Gap(2),
                    Row(
                      children: [
                        Text(
                          state.favoritesMusic.length.toString() + " " + AppLocalizations.of(context).getTranslate("favorites_songCount"),
                          style: TextStyle(
                            color: Color.fromARGB(255, 157, 162, 170),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: clientCubit.state.darkMode
                                  ? Color.fromARGB(255, 157, 162, 170)
                                  : Colors.black87,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.download_rounded,
                              size: 15,
                              color: clientCubit.state.darkMode
                                  ? Color.fromARGB(255, 157, 162, 170)
                                  : Colors.black87),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: clientCubit.state.darkMode
                                ? Color.fromARGB(255, 234, 234, 234)
                                : Colors.black87,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.play_arrow,
                              size: 22,
                              color: clientCubit.state.darkMode
                                  ? Colors.black87
                                  : Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(10),
              Expanded(
                child: ListView.builder(
                  itemCount: state.favoritesMusic.length,
                  itemBuilder: (context, index) => QuickPicksMusic(
                    size,
                    state.favoritesMusic[index]["photo"].toString(),
                    state.favoritesMusic[index]["title"].toString(),
                    state.favoritesMusic[index]["artist"].toString(),
                    index,
                    state,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget QuickPicksMusic(Size size, String photo, String title, String artist,
      int index, FavoritesState state) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                height: 60,
                width: 60,
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
                                ? Colors.white : Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    artist,
                    style: TextStyle(
                      color: Color.fromARGB(255, 150, 150, 150),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "Favorilerden Kaldir",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      surfaceTintColor: Color.fromARGB(255, 200, 200, 200),
                      content: Text(
                        "Favorilerden kaldirmak istediğinize emin misiniz ?",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () => GoRouter.of(context).pop(),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.black87),
                            ),
                            child: Text(
                              "İptal",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              favoritesCubit.removeFromFavorites(
                                  id: state.favoritesMusic[index]["id"] as int);

                              GoRouter.of(context).pop();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.black87),
                            ),
                            child: Text(
                              "Kaldir",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            )),
                      ],
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.favorite, size: 20, color: clientCubit.state.darkMode
                                ? Colors.white : Colors.black87),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.more_vert, color: clientCubit.state.darkMode
                                ? Colors.white : Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
