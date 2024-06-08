import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  splashScreen() async {
    Future.delayed(const Duration(milliseconds: 2000), () {
      GoRouter.of(context).replace("/authLoad");
    });
  }

  @override
  void initState() {
    super.initState();
    splashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(251, 98, 54, 103),
                Color.fromARGB(255, 134, 61, 186),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Gap(20),
                  Image.asset("assets/images/logoApp.png", height: 105),
                  Gap(10),
                  Text(
                    "Rosetune",
                    style: TextStyle(
                      color: Colors.white,
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
