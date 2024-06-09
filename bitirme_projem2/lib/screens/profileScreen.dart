import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

import '../bloc/client/client_cubit.dart';
import '../engine/localizations.dart';
import '../engine/storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  File? file;
  // File? cacheFile;
  Uint8List? imageBytes;
  profilVarsaYukle() async {
    final Directory appCacheDir = await getApplicationCacheDirectory();
    File f = File("${appCacheDir.path}/avatar.jpg");

    if (f.existsSync()) {
      setState(() {
        imageBytes = f.readAsBytesSync();
      });
    }
  }

  profilePhotoUpdate() async {
    try {
      ImagePicker iPicker = ImagePicker();

      XFile? selectedFile = await iPicker.pickImage(
          source: ImageSource.gallery, requestFullMetadata: false);

      if (selectedFile == null) {
        setState(() {
          file = null;
          imageBytes = null;
        });
        return;
      }

      var dosyaFormati = selectedFile.name.split(".").last;

      bool kuculebilirMi = false;

      switch (dosyaFormati.toLowerCase()) {
        case ("jpg"):
        case ("jpeg"):
        case ("png"):
        case ("bmp"):
        case ("tiff"):
        case ("ico"):
        case ("gif"):
          kuculebilirMi = true;
          break;
      }

      if (!kuculebilirMi) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Dosya Tipi",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              "Seçilen dosya türü desteklenmiyor",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black87),
                  ),
                  child: Text(
                    "Tamam",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  )),
            ],
          ),
        );
        return;
      }

      Uint8List fileBytes = await selectedFile.readAsBytes();
      img.Image? temp = img.decodeImage(fileBytes);

      // img.Image? temp;

      if (dosyaFormati.toLowerCase() == "jpg" || dosyaFormati.toLowerCase() == "jpeg") {
        temp = img.decodeJpg(File(selectedFile.path).readAsBytesSync());
      }
      else if (dosyaFormati.toLowerCase() == "png") {
        temp = img.decodePng(File(selectedFile.path).readAsBytesSync());
      }
      else if (dosyaFormati.toLowerCase() == "bmp") {
        temp = img.decodeBmp(File(selectedFile.path).readAsBytesSync());
      }
      else if (dosyaFormati.toLowerCase() == "gif") {
        temp = img.decodeGif(File(selectedFile.path).readAsBytesSync());
      }
      else if (dosyaFormati.toLowerCase() == "tiff") {
        temp = img.decodeTiff(File(selectedFile.path).readAsBytesSync());
      }
      else if (dosyaFormati.toLowerCase() == "ico") {
        temp = img.decodeIco(File(selectedFile.path).readAsBytesSync());
      }

      if (temp!.width < 500 || temp.height < 359) {
        showDialog(
          context: context,
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
            content: Text(
              "Seçilen dosyanin boyutu çok küçük, en az 500x359 seçmelisiniz",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black87),
                  ),
                  child: Text(
                    "Tamam",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  )),
            ],
          ),
        );

        return;
      }

      // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
      img.Image thumbnail;
      if (temp.width >= temp.height) {
        thumbnail = img.copyResize(temp, height: 500);
      }
      else {
        thumbnail = img.copyResize(temp, width: 500);
      }
      // Save the thumbnail to a jpeg file.
      final resizedFileData = img.encodeJpg(thumbnail, quality: 85);

      Uint8List resizedBytes = Uint8List.fromList(img.encodeJpg(thumbnail, quality: 85));

      // final Directory tempDir = await getTemporaryDirectory();
      // final Directory appSupportDir = await getApplicationSupportDirectory();
      final Directory appCacheDir = await getApplicationCacheDirectory();

      File yeniDosyam = File("${appCacheDir.path}/avatar.jpg");
      yeniDosyam.writeAsBytesSync(resizedFileData);

      setState(() {
        file = yeniDosyam;
        imageBytes = resizedBytes;
      });

    } on Exception catch (e) {
      print("Bir hata oluştu");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
    clientCubit = context.read<ClientCubit>();
    profilVarsaYukle();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: clientCubit.state.darkMode
            ? Color.fromARGB(255, 40, 32, 25)
            : Color.fromARGB(255, 251, 251, 251),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Upside(),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: clientCubit.state.darkMode
                                          ? Color.fromARGB(255, 240, 135, 64)
                                          : Colors.black87,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "FOLLOW",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(221, 212, 212, 212),
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "MESSAGE",
                                          style: TextStyle(
                                            color: clientCubit.state.darkMode
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 34,
                          ),
                          DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                TabBar(
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicatorColor: Colors.black87,
                                  indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      width: 3,
                                      color: clientCubit.state.darkMode
                                          ? Color.fromARGB(255, 240, 135, 64)
                                          : Colors.black87,
                                    ),
                                  ),
                                  indicatorPadding:
                                      EdgeInsets.symmetric(vertical: 3),
                                  labelColor: clientCubit.state.darkMode
                                      ? Color.fromARGB(255, 225, 224, 223)
                                      : Colors.black87,
                                  overlayColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                  unselectedLabelColor:
                                      Color.fromARGB(255, 176, 176, 176),
                                  dividerColor: Colors.transparent,
                                  dividerHeight: 2,
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        AppLocalizations.of(context).getTranslate("profile_portfolio"),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        AppLocalizations.of(context).getTranslate("profile_playlist2"),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 268,
                                  child: TabBarView(
                                    children: [
                                      Container(
                                        child:
                                            Center(child: Text(AppLocalizations.of(context).getTranslate("profile_photo"))),
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  playlistItem(
                                                      "assets/images/playlistImage1.jpg",
                                                      "Karişik",
                                                      "16 Şarki",
                                                      () {}),
                                                  playlistItem(
                                                      "assets/images/playlistImage3.jpg",
                                                      "Rock",
                                                      "13 Şarki",
                                                      () {}),
                                                  playlistItem(
                                                      "assets/images/playlistImage4.jpg",
                                                      "Jazz",
                                                      "9 Şarki",
                                                      () {}),
                                                  playlistItem(
                                                      "assets/images/playlistImage2.jpg",
                                                      "Türkçe",
                                                      "17 Şarki",
                                                      () {}),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: Divider(
                                                    color: clientCubit
                                                            .state.darkMode
                                                        ? Color.fromARGB(
                                                            41, 255, 255, 255)
                                                        : Colors.grey.shade300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.favorite_border,
                                                          color: clientCubit
                                                                  .state
                                                                  .darkMode
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  240,
                                                                  135,
                                                                  64)
                                                              : Colors.black87,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "120",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: clientCubit
                                                                    .state
                                                                    .darkMode
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        225,
                                                                        224,
                                                                        223)
                                                                : Colors
                                                                    .black87,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .chat_bubble_outline,
                                                          color: clientCubit
                                                                  .state
                                                                  .darkMode
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  240,
                                                                  135,
                                                                  64)
                                                              : Colors.black87,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Yorum",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: clientCubit
                                                                    .state
                                                                    .darkMode
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        225,
                                                                        224,
                                                                        223)
                                                                : Colors
                                                                    .black87,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.share,
                                                          color: clientCubit
                                                                  .state
                                                                  .darkMode
                                                              ? Color.fromARGB(
                                                                  255,
                                                                  240,
                                                                  135,
                                                                  64)
                                                              : Colors.black87,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Paylaş",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: clientCubit
                                                                    .state
                                                                    .darkMode
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        225,
                                                                        224,
                                                                        223)
                                                                : Colors
                                                                    .black87,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playlistItem(
      String photo, String title, String count, final Function()? onTap) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 150,
          height: 200,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(photo),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    color: clientCubit.state.darkMode
                        ? Color.fromARGB(255, 225, 224, 223)
                        : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                count,
                style: TextStyle(
                  color: Color.fromARGB(255, 176, 176, 176),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Upside() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              InkWell(
                onTap: () {},
                child: profileSection("153K", AppLocalizations.of(context).getTranslate("profile_follower")),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {},
                child: profileSection("100K", AppLocalizations.of(context).getTranslate("profile_follow")),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.0, 0.3, 0.0, 0.0, 1],
                      colors: clientCubit.state.darkMode
                          ? [
                              Color.fromARGB(255, 40, 32, 25),
                              Color.fromARGB(255, 40, 32, 25),
                              Color.fromARGB(255, 202, 111, 47),
                              Color.fromARGB(255, 202, 111, 47),
                              Color.fromARGB(255, 202, 111, 47),
                            ]
                          : [
                              Color.fromARGB(255, 251, 251, 251),
                              Color.fromARGB(255, 251, 251, 251),
                              Color.fromARGB(255, 132, 132, 132),
                              Color.fromARGB(255, 132, 132, 132),
                              Color.fromARGB(255, 132, 132, 132),
                            ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: clientCubit.state.darkMode
                          ? Color.fromARGB(255, 40, 32, 25)
                          : Color.fromARGB(255, 251, 251, 251),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes!)
                          : AssetImage("assets/images/profil1.jpg") as ImageProvider<Object>,
                      radius: 38,
                      child: Container(
                        alignment: Alignment.topRight,
                        height: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: profilePhotoUpdate,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: clientCubit.state.darkMode
                                      ? Theme.of(context).colorScheme.onBackground
                                      : Colors.black87,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/pen.svg",
                                  height: 13,
                                  colorFilter: ColorFilter.mode(
                                      clientCubit.state.darkMode
                                          ? Theme.of(context)
                                              .colorScheme
                                              .background
                                          : Colors.white,
                                      BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 250,
                  child: Text(
                    "Berkay T",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: clientCubit.state.darkMode
                          ? Color.fromARGB(255, 225, 224, 223)
                          : Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Color.fromARGB(255, 185, 185, 185),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Los Angeles",
                      style: TextStyle(
                        color: Color.fromARGB(255, 185, 185, 185),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          profileSection("4", AppLocalizations.of(context).getTranslate("profile_playlist")),
        ],
      ),
    );
  }

  Widget profileSection(String number, String name) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            color: clientCubit.state.darkMode
                ? Color.fromARGB(255, 225, 224, 223)
                : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          name,
          style: TextStyle(
            color: Color.fromARGB(255, 185, 185, 185),
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
