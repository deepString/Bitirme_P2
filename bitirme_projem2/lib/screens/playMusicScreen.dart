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
                      ],
                    ),
                  ),
                ),
        ),
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
