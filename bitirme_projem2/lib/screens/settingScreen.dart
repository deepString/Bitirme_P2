import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../bloc/client/client_cubit.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late ClientCubit clientCubit;

  @override
  void initState() {
    super.initState();
    clientCubit = context.read<ClientCubit>();
  }

  List<bool> switchChange = [false, false];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: clientCubit.state.darkMode
              ? Color.fromARGB(255, 30, 30, 30)
              : null,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: Text(
              "Ayarlar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Color.fromARGB(255, 234, 234, 234),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SettingsItem("Profili Düzenle", "Profili düzenleyin", () {}),
                SettingsItem("Ekolayzer", "Ses ayarlarini düzenleyin", () {}),
                SettingsItem(
                    "Depolama", "Depolama ayarlarini kontrol edin", () {}),
                SettingsItem("Bildirimler", "Bildirimleri yönetin", () {}),
                SettingsItemSwitch(
                    "Sansürsüz içeriğe izin ver",
                    "Sansürsüz içerikleri çalmak için bu seçeneği etkinleştirmelisin",
                    0),
                SettingsItemSwitch("Yüksek ses kalitesi",
                    "Yüksek hizli internet gerektirir", 1),
                Container(
                  margin: EdgeInsets.only(right: 10, left: 20, top: 8),
                  width: double.infinity,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Diller",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "Türkçe",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: () {},
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 5, vertical: 8),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           "Dil",
                      //           style: TextStyle(
                      //             color: Color.fromARGB(255, 240, 240, 240),
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.w400,
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.only(right: 5),
                      //           child: Text(
                      //             "English",
                      //             style: TextStyle(
                      //               color: Color.fromARGB(255, 240, 240, 240),
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.w500,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Row(
                        children: [
                          Gap(20),
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(40, 225, 225, 225),
                            ),
                          ),
                          Gap(10),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10, left: 20, top: 8),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 1, left: 5, top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  clientCubit.state.darkMode
                                      ? "DarkMode"
                                      : "LightMode",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Gap(6),
                                Icon(
                                    clientCubit.state.darkMode
                                        ? Icons.nightlight_outlined
                                        : Icons.wb_sunny_outlined,
                                    size: 19,
                                    color: Color.fromARGB(255, 240, 240, 240)),
                              ],
                            ),
                            Container(
                              height: 20,
                              child: Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                  value: clientCubit.state.darkMode,
                                  onChanged: (value) {
                                    clientCubit.changeDarkMode(darkMode: value);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Gap(20),
                          Expanded(
                            child: Divider(
                              color: Color.fromARGB(40, 225, 225, 225),
                            ),
                          ),
                          Gap(10),
                        ],
                      ),
                    ],
                  ),
                ),
                SettingsItem("İzinler", "İzinleri yönetin", () {}),
                SettingsItem("Gizlilik Politikasi",
                    "Gizliliğinizle ilgili bilgi alin", () {}),
                SettingsItem("Yardim Merkezi",
                    "Yardima ihtiyaciniz varsa destek alin", () {}),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 40),
                  child: FilledButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    child: Text(
                      "Oturumu Kapat",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget SettingsItemSwitch(String title, String description, int indexSwitch) {
    return Container(
      margin: EdgeInsets.only(right: 10, left: 20, top: 8),
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(right: 1, left: 5, top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 300,
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Gap(2),
                        Row(
                          children: [
                            Container(
                              width: 300,
                              child: Text(
                                description,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 170, 170, 170),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 20,
                  child: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: switchChange[indexSwitch],
                      onChanged: (value) {
                        setState(() {
                          switchChange[indexSwitch] = value;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              Gap(20),
              Expanded(
                child: Divider(
                  color: Color.fromARGB(40, 225, 225, 225),
                ),
              ),
              Gap(10),
            ],
          ),
        ],
      ),
    );
  }

  Widget SettingsItem(String title, String description, Function()? onTap) {
    return Container(
      margin: EdgeInsets.only(right: 10, left: 20, top: 8),
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 300,
                            child: Text(
                              title,
                              style: TextStyle(
                                color: Color.fromARGB(255, 240, 240, 240),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      Gap(2),
                      Row(
                        children: [
                          Container(
                            width: 300,
                            child: Text(
                              description,
                              style: TextStyle(
                                color: Color.fromARGB(255, 170, 170, 170),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right,
                      size: 20, color: Color.fromARGB(255, 240, 240, 240)),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Gap(20),
              Expanded(
                child: Divider(
                  color: Color.fromARGB(40, 225, 225, 225),
                ),
              ),
              Gap(10),
            ],
          ),
        ],
      ),
    );
  }
}
