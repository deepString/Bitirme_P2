import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../bloc/client/client_cubit.dart';
import '../engine/cache.dart';
import '../engine/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ClientCubit clientCubit;

  Map<String, dynamic> pageConfig = {};
  bool configLoaded = false;

  splashScreen() async {

    CacheSystem cs = CacheSystem();
    final pageConfig = await cs.getSplashConfig();
    setState(() {
      this.pageConfig = pageConfig;
      configLoaded = true;
    });

    Future.delayed(Duration(milliseconds: pageConfig["duration"]), () {
      GoRouter.of(context).replace("/authLoad");
    });
  }

  @override
  void initState() {
    super.initState();
    splashScreen();
    clientCubit = context.read<ClientCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return !configLoaded
        ? const SizedBox()
        : SafeArea(
            child: Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: pageConfig["backgroundColor"].isNotEmpty
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomCenter,
                          colors: [
                            HexColor(pageConfig["backgroundColor"][0]),
                            HexColor(pageConfig["backgroundColor"][1]),
                          ],
                        ),
                      )
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Gap(20),
                        if (pageConfig["logo"].isNotEmpty)
                          if (pageConfig["logo"].startsWith("https://"))
                            Image.network(pageConfig["logo"], height: 105)
                          else
                            Image.asset(pageConfig["logo"], height: 105),
                        Gap(10),
                        Text(
                          "Rosetune",
                          style: TextStyle(
                            color: clientCubit.state.darkMode
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 48,
                            fontFamily: "Pacifico",
                          ),
                        ),
                      ],
                    ),
                    CircularProgressIndicator(
                      color: Color.fromARGB(255, 161, 200, 251),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
