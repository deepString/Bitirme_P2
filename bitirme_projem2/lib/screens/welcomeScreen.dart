import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/loginArkaPlan1.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(240, 237, 127, 94),
                  Color.fromARGB(240, 60, 47, 38),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Rosetune",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontFamily: "Pacifico",
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () => GoRouter.of(context).push("/register"),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 86, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "Kayit Ol",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 95, 67, 50),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      InkWell(
                        onTap: () => GoRouter.of(context).push("/login"),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 80, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: Text(
                            "Giriş Yap",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
