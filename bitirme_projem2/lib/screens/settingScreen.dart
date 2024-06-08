import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../bloc/client/client_cubit.dart';
import '../engine/localizations.dart';

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
              : Color.fromARGB(255, 251, 251, 251),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: Text(
              AppLocalizations.of(context).getTranslate("settings_appbar"),
              style: TextStyle(
                color:
                    clientCubit.state.darkMode ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: clientCubit.state.darkMode
                  ? Color.fromARGB(255, 234, 234, 234)
                  : Colors.black87,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SettingsItem(AppLocalizations.of(context).getTranslate("settings1"), AppLocalizations.of(context).getTranslate("settings1_description"), () {}),
                SettingsItem(AppLocalizations.of(context).getTranslate("settings2"), AppLocalizations.of(context).getTranslate("settings2_description"), () {}),
                SettingsItem(
                    AppLocalizations.of(context).getTranslate("settings3"), AppLocalizations.of(context).getTranslate("settings3_description"), () {}),
                SettingsItem(AppLocalizations.of(context).getTranslate("settings4"), AppLocalizations.of(context).getTranslate("settings4_description"), () {}),
                SettingsItemSwitch(
                    AppLocalizations.of(context).getTranslate("settings5"),
                    AppLocalizations.of(context).getTranslate("settings5_description"),
                    0),
                SettingsItemSwitch(AppLocalizations.of(context).getTranslate("settings6"),
                    AppLocalizations.of(context).getTranslate("settings6_description"), 1),
                Container(
                  margin: EdgeInsets.only(right: 10, left: 20, top: 8),
                  width: double.infinity,
                  child: Column(
                    children: [
                      if (clientCubit.state.language == "tr")
                        InkWell(
                          onTap: () {
                            clientCubit.changeLanguage(language: "en");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .getTranslate("settings7"),
                                  style: TextStyle(
                                    color: clientCubit.state.darkMode
                                        ? Color.fromARGB(255, 240, 240, 240)
                                        : Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    "Türkçe",
                                    style: TextStyle(
                                      color: clientCubit.state.darkMode
                                          ? Color.fromARGB(255, 240, 240, 240)
                                          : Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        InkWell(
                          onTap: () {
                            clientCubit.changeLanguage(language: "tr");
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .getTranslate("settings7"),
                                  style: TextStyle(
                                    color: clientCubit.state.darkMode
                                        ? Color.fromARGB(255, 240, 240, 240)
                                        : Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Text(
                                    "English",
                                    style: TextStyle(
                                      color: clientCubit.state.darkMode
                                          ? Color.fromARGB(255, 240, 240, 240)
                                          : Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          Gap(20),
                          Expanded(
                            child: Divider(
                              color: clientCubit.state.darkMode
                                  ? Color.fromARGB(40, 225, 225, 225)
                                  : Color.fromARGB(60, 0, 0, 0),
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
                                      ? AppLocalizations.of(context).getTranslate("settings8.1")
                                      : AppLocalizations.of(context).getTranslate("settings8.2"),
                                  style: TextStyle(
                                    color: clientCubit.state.darkMode
                                        ? Color.fromARGB(255, 240, 240, 240)
                                        : Colors.black87,
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
                                    color: clientCubit.state.darkMode
                                        ? Color.fromARGB(255, 240, 240, 240)
                                        : Colors.black87),
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
                              color: clientCubit.state.darkMode
                                  ? Color.fromARGB(40, 225, 225, 225)
                                  : Color.fromARGB(60, 0, 0, 0),
                            ),
                          ),
                          Gap(10),
                        ],
                      ),
                    ],
                  ),
                ),
                SettingsItem(AppLocalizations.of(context).getTranslate("settings9"), AppLocalizations.of(context).getTranslate("settings9_description"), () {}),
                SettingsItem(AppLocalizations.of(context).getTranslate("settings10"),
                    AppLocalizations.of(context).getTranslate("settings10_description"), () {}),
                SettingsItem(AppLocalizations.of(context).getTranslate("settings11"),
                    AppLocalizations.of(context).getTranslate("settings11_description"), () {}),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 40),
                  child: FilledButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          clientCubit.state.darkMode
                              ? Colors.white
                              : Colors.black87),
                    ),
                    child: Text(
                      AppLocalizations.of(context).getTranslate("settings_signOut"),
                      style: TextStyle(
                        color: clientCubit.state.darkMode
                            ? Colors.black87
                            : Colors.white,
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
                                  color: clientCubit.state.darkMode
                                      ? Color.fromARGB(255, 240, 240, 240)
                                      : Colors.black87,
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
                  color: clientCubit.state.darkMode
                      ? Color.fromARGB(40, 225, 225, 225)
                      : Color.fromARGB(60, 0, 0, 0),
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
                                color: clientCubit.state.darkMode
                                    ? Color.fromARGB(255, 240, 240, 240)
                                    : Colors.black87,
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
                      size: 20,
                      color: clientCubit.state.darkMode
                          ? Color.fromARGB(255, 240, 240, 240)
                          : Colors.black87),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Gap(20),
              Expanded(
                child: Divider(
                  color: clientCubit.state.darkMode
                      ? Color.fromARGB(40, 225, 225, 225)
                      : Color.fromARGB(60, 0, 0, 0),
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
