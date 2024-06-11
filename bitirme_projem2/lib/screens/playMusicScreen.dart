import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../models/songModel.dart';
import '../services/api.dart';

class PlayMusicScreen extends StatefulWidget {
  const PlayMusicScreen({super.key});

  @override
  State<PlayMusicScreen> createState() => _PlayMusicScreenState();
}

class _PlayMusicScreenState extends State<PlayMusicScreen> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool isMusicRoomOpen = false;
  bool isMicrophneOn = false;

  late StreamSubscription<PlayerState> playerStateSubscription;
  late StreamSubscription<Duration> positionSubscription;
  late StreamSubscription<Duration> durationSubscription;

  List<Songs>? sarkiBilgileri;
  int currentSongIndex = 0;

  sarkiListesi() async {
    API api = API();
    var sonuc = await api.songList();
    var sarkilar = (sonuc as List).map((e) => Songs.fromJson(e)).toList();
    setState(() {
      sarkiBilgileri = sarkilar;
    });
  }

  @override
  void initState() {
    super.initState();
    sarkiListesi();

    playerStateSubscription = audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    durationSubscription = audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    positionSubscription = audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });
  }

  Future setAudio() async {
    try {
      audioPlayer.setReleaseMode(ReleaseMode.loop);

      final player = AudioCache(prefix: "assets/");
      final songUrl = await player.load(sarkiBilgileri![currentSongIndex].url!);
      await audioPlayer.setSourceUrl(songUrl.path);
    } on Exception catch (e) {
      print("Dosya açilirken bir hata meydana geldi: $e");
    }
  }

  nextSong() async {
    if (currentSongIndex < sarkiBilgileri!.length - 1) {
      currentSongIndex++;
      await setAudio();
      await audioPlayer.resume();
    }
  }

  previousSong() async {
    if (currentSongIndex > 0) {
      currentSongIndex--;
      await setAudio();
      await audioPlayer.resume();
    }
  }

  bottomSheetDurumuGuncelle(bool bottomSheetState) {
    setState(() {
      isMusicRoomOpen = bottomSheetState;
    });
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    positionSubscription.cancel();
    durationSubscription.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Hero(
        tag: "playMusicTag",
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () async {
                await audioPlayer.stop();
                GoRouter.of(context).pop();
              },
              icon: Icon(Icons.keyboard_arrow_down,
                  size: 30, color: Colors.white),
            ),
            actions: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setModalState) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Color.fromARGB(255, 20, 71, 113),
                          ),
                          height: 260,
                          width: double.infinity,
                          child: isMusicRoomOpen
                              ? Column(
                                  children: [
                                    Gap(10),
                                    Container(
                                      height: 3,
                                      width: 30,
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color:
                                            Color.fromARGB(151, 255, 255, 255),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  "Odayi Kapatiyorsunuz",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                backgroundColor: Colors.white,
                                                content: Text(
                                                  "Odayi kapatmak istediğine emin misin?",
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () =>
                                                          GoRouter.of(context)
                                                              .pop(),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.black87),
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
                                                        setModalState(() {
                                                          isMusicRoomOpen =
                                                              false;
                                                        });
                                                        bottomSheetDurumuGuncelle(false);
                                                        GoRouter.of(context)
                                                            .pop();
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.black87),
                                                      ),
                                                      child: Text(
                                                        "Odayi Kapat",
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
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              "Odayi Kapat",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Gap(25),
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Color.fromARGB(
                                                              255,
                                                              240,
                                                              135,
                                                              64),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(3),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    20,
                                                                    71,
                                                                    113),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: CircleAvatar(
                                                            backgroundImage:
                                                                AssetImage(
                                                                    "assets/images/profil1.jpg"),
                                                            backgroundColor:
                                                                Colors.white,
                                                            radius: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      Gap(10),
                                                      Container(
                                                        width: 150,
                                                        child: Text(
                                                          "Berkay",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 1),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color.fromARGB(
                                                          255, 236, 237, 237),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    "Oda sahibi",
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 236, 237, 237),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons.message,
                                                          size: 20,
                                                          color: Colors.white),
                                                    ),
                                                    Gap(5),
                                                    IconButton(
                                                      onPressed: () {
                                                        setModalState(() {
                                                          isMicrophneOn =
                                                              !isMicrophneOn;
                                                        });
                                                      },
                                                      icon: Icon(
                                                          isMicrophneOn
                                                              ? Icons.mic
                                                              : Icons.mic_off,
                                                          size: 20,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Gap(20),
                                              Expanded(
                                                child: Divider(
                                                  color: Color.fromARGB(
                                                      82, 255, 255, 255),
                                                ),
                                              ),
                                              Gap(20),
                                            ],
                                          ),
                                          IncomingUsers(
                                              "assets/images/profile2.jpg",
                                              "Kullanici1",
                                              true,
                                              true),
                                          IncomingUsers(
                                              "assets/images/profile3.jpg",
                                              "Kullanici2",
                                              false,
                                              false),
                                          IncomingUsers(
                                              "assets/images/profile4.jpg",
                                              "Kullanici3",
                                              true,
                                              false),
                                          IncomingUsers(
                                              "assets/images/profile5.webp",
                                              "Kullanici4",
                                              false,
                                              false),
                                          IncomingUsers(
                                              "assets/images/profile6.jpg",
                                              "Kullanici4",
                                              false,
                                              false),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  child: Column(
                                    children: [
                                      Gap(40),
                                      IconButton(
                                        onPressed: () {
                                          setModalState(() {
                                            isMusicRoomOpen = true;
                                            bottomSheetDurumuGuncelle(true);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Gap(10),
                                      Text(
                                        "Oda Oluştur",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      });
                    },
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    "Müzik Odasi",
                    style: TextStyle(
                      color: Color.fromARGB(255, 44, 197, 218),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert, size: 25, color: Colors.white),
              ),
              Gap(6),
            ],
          ),
          body: sarkiBilgileri == null
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 20, 71, 113),
                        Color.fromARGB(255, 7, 26, 44),
                      ],
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 20, 71, 113),
                        Color.fromARGB(255, 7, 26, 44),
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Gap(70),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          height: 250,
                          width: size.width - 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  sarkiBilgileri![currentSongIndex].photo ??
                                      "assets/images/musicImgood.jpg"),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 28, vertical: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sarkiBilgileri![currentSongIndex]
                                              .musicName ??
                                          "Unknown Song",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      sarkiBilgileri![currentSongIndex]
                                              .artist ??
                                          "Unknown Artist",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 188, 188, 188),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_border,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            )),
                            child: Slider(
                              min: 0,
                              max: duration.inSeconds.toDouble(),
                              value: position.inSeconds.toDouble(),
                              thumbColor: Colors.white,
                              onChanged: (value) async {
                                final position =
                                    Duration(seconds: value.toInt());
                                await audioPlayer.seek(position);

                                await audioPlayer.resume();
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 28),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatTime(position),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 188, 188, 188),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                formatTime(duration),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 188, 188, 188),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: SvgPicture.asset(
                                    "assets/icons/shuffle.svg",
                                    height: 18,
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    iconSize: 30,
                                    onPressed: previousSong,
                                    icon: Icon(Icons.skip_previous,
                                        color: Colors.white),
                                  ),
                                  Gap(10),
                                  IconButton(
                                    iconSize: 30,
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.white),
                                    ),
                                    onPressed: () async {
                                      if (isPlaying == true) {
                                        await audioPlayer.pause();
                                      } else {
                                        if (audioPlayer.state !=
                                            PlayerState.playing) {
                                          setAudio();
                                        }
                                        await audioPlayer.resume();
                                      }
                                    },
                                    icon: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.black87),
                                  ),
                                  Gap(10),
                                  IconButton(
                                    iconSize: 30,
                                    onPressed: nextSong,
                                    icon: Icon(Icons.skip_next,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: SvgPicture.asset(
                                    "assets/icons/refreshButton.svg",
                                    height: 18,
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 28, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: SvgPicture.asset(
                                    "assets/icons/device.svg",
                                    height: 18,
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                              if (isMusicRoomOpen == true)
                              Text(
                                "Müzik odaniz açik",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 44, 197, 218),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(Icons.share,
                                      size: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Icon(Icons.keyboard_arrow_up,
                                  color: Colors.white),
                              Text(
                                "Şarki Sözleri",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget IncomingUsers(
      String photo, String name, bool isAuthorized, bool isMic) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 240, 135, 64),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 20, 71, 113),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(photo),
                      backgroundColor: Colors.white,
                      radius: 16,
                    ),
                  ),
                ),
                Gap(10),
                Container(
                  width: 180,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isAuthorized == true)
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: SvgPicture.asset(
                "assets/icons/crown.svg",
                height: 18,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                child: Icon(isMic ? Icons.mic : Icons.mic_off,
                    size: 18, color: Colors.white),
              ),
              Gap(5),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert, size: 20, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
  }
}
