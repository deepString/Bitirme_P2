import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../engine/storage.dart';
import '../responsive/responsive.dart';
import '../services/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool passwordVisible = true;
  bool rememberUser = false;
  bool switchChange = false;
  bool loading = false;
  bool emailFormat = false;
  // İlk başlangıçta email formatı false yani yanlış. Çünkü henüz email kutusu boş
  bool isEmailEmpty = true;
  // Eğer hiçbir bilgi girilmediyse hata mesajı vermesin diye isEmailEmpty tanımladım
  bool isPasswordEmpty = true;
  // İlk başta kutular boş geldiği için değerleri true yani boş olarak tanımladım

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Screens device = Screens.mobile;

  drawScreen () {
    switch (device) {
      case (Screens.mobile):
        return MobileBuild(context, 325, 325, 300);
      case (Screens.tablet):
        return Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              width: 250,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/loginArkaPlan2.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: switchChange
                        ? [
                            Color.fromARGB(170, 45, 195, 227),
                            Color.fromARGB(245, 32, 26, 49),
                          ]
                        : [
                            Color.fromARGB(170, 155, 86, 251),
                            Color.fromARGB(239, 40, 31, 25),
                          ],
                  ),
                ),
              ),
            ),
            Expanded(child: MobileBuild(context, 350, 350, 330),),
          ],
        );
      case (Screens.desktop):
        return Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/loginArkaPlan1.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Container(
                  color: Color.fromARGB(240, 60, 47, 38),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/logoApp.png", height: 120),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: DesktopBuild(context, 350, 350, 330),),
          ],
        );
    }
  }

  login() async {
    setState(() {
      loading = true;
    });

    API api = API();
    final response = await api.loginUser(
      mail: emailController.text,
      passwords: passwordController.text,
    );

    if (response is Exception) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email adresi veya şifre hatali"),
        backgroundColor: Colors.red.shade300,
      ));
    } 
    else {
      Storage storage = Storage();

      await storage.saveUser(
          id: response["id"],
          name: "Berkay");

      await storage.saveToken(response["token"]);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Başariyla giriş yaptin!"),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
      ));

      GoRouter.of(context).replace("/home");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Ekran genişliği kontrolü
    setState(() {
      device = detectScreen(MediaQuery.of(context).size);
    });

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: switchChange
            ? Color.fromARGB(255, 32, 26, 49)
            : Color.fromARGB(255, 251, 251, 251),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : drawScreen(),
      ),
    );
  }

  Center MobileBuild(BuildContext context, double emailWidth, double passwordWidth, double buttonWidth) {
    return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 16, left: 16, top: 65, bottom: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 20,
                            child: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: switchChange,
                                onChanged: (value) {
                                  setState(() {
                                    switchChange = value;
                                  });
                                },
                                activeThumbImage:
                                    AssetImage("assets/images/nightMode.png"),
                                inactiveThumbImage:
                                    AssetImage("assets/images/lightMode.png"),
                                activeTrackColor: Colors.white,
                                trackOutlineColor:
                                    MaterialStatePropertyAll(Colors.grey),
                                thumbColor:
                                    MaterialStatePropertyAll(Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Image.asset("assets/images/logoApp.png", height: 90),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Tekrar Hoşgeldin!",
                        style: TextStyle(
                          color: switchChange ? Colors.white : Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Hesabiniza erişmek için",
                              style: TextStyle(
                                color: switchChange
                                    ? Color.fromARGB(255, 148, 144, 159)
                                    : Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(text: " "),
                            TextSpan(
                              text: "oturum açiniz",
                              style: TextStyle(
                                color: switchChange
                                    ? Color.fromARGB(255, 14, 236, 219)
                                    : Color.fromARGB(240, 102, 50, 142),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      emailBox("Email", Icons.mail, "E-posta adresi", emailWidth),
                      passwordBox("Şifre", Icons.lock, "Şifre", passwordWidth),
                      Container(
                        width: 325,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  side: BorderSide(
                                    color: switchChange
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            240, 102, 50, 142),
                                  ),
                                  value: rememberUser,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberUser = value ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  "Beni hatirla",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: switchChange
                                        ? Colors.white
                                        : Color.fromARGB(240, 102, 50, 142),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              hoverColor: Colors.transparent,
                              splashColor: switchChange
                                  ? Color.fromARGB(255, 32, 26, 49)
                                  : Color.fromARGB(255, 251, 251, 251),
                              highlightColor: switchChange
                                  ? Color.fromARGB(255, 32, 26, 49)
                                  : Color.fromARGB(255, 251, 251, 251),
                              onTap: () {
                                GoRouter.of(context).push("/resetPass");
                              },
                              child: Text(
                                "Şifremi Unuttum",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: switchChange
                                      ? Colors.white
                                      : Color.fromARGB(240, 102, 50, 142),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        hoverColor: Colors.transparent,
                        splashColor: switchChange
                            ? Color.fromARGB(255, 32, 26, 49)
                            : Color.fromARGB(255, 251, 251, 251),
                        highlightColor: switchChange
                            ? Color.fromARGB(255, 32, 26, 49)
                            : Color.fromARGB(255, 251, 251, 251),
                        onTap: () {
                          if (isEmailEmpty == false && isPasswordEmpty == false) {
                            if (emailFormat == true) {
                              login();
                            } 
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Email formatiniz yanliş, lütfen kontrol ediniz"),
                                backgroundColor: Colors.red.shade300,
                                behavior: SnackBarBehavior.floating,
                              ));
                            }
                          } 
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Lütfen ilgili alanlari doldurunuz"),
                              backgroundColor: Colors.red.shade300,
                              behavior: SnackBarBehavior.fixed,
                            ));
                          }
                        },
                        child: Container(
                          width: buttonWidth,
                          padding: EdgeInsets.symmetric(
                              horizontal: 70, vertical: 13),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                switchChange
                                    ? Color.fromARGB(255, 14, 236, 219)
                                    : const Color.fromARGB(
                                        255, 156, 124, 249),
                                const Color.fromARGB(255, 127, 85, 247),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Giriş Yap",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Hesabin yok mu?",
                              style: TextStyle(
                                color: switchChange
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            TextSpan(text: " "),
                            TextSpan(
                              text: "Şimdi kayit ol",
                              recognizer: TapGestureRecognizer()..onTap = () {
                                  GoRouter.of(context).replace("/register");
                                },
                              style: TextStyle(
                                color: switchChange
                                    ? Color.fromARGB(255, 14, 236, 219)
                                    : Color.fromARGB(240, 102, 50, 142),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 325,
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: switchChange
                                    ? Colors.white
                                    : Color.fromARGB(136, 155, 155, 155),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Veya",
                              style: TextStyle(
                                fontSize: 10,
                                color: switchChange
                                    ? Colors.white
                                    : const Color.fromARGB(
                                        136, 155, 155, 155),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Divider(
                                color: switchChange
                                    ? Colors.white
                                    : const Color.fromARGB(
                                        136, 155, 155, 155),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 25),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 249, 249, 253),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Color.fromARGB(255, 230, 233, 246),
                            ),
                          ),
                          child: Image.asset(
                            "assets/images/googleLogo.png",
                            width: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
  }

  Center DesktopBuild(BuildContext context, double emailWidth, double passwordWidth, double buttonWidth) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 65, bottom: 16),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                "Tekrar Hoşgeldin!",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Hesabiniza erişmek için",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(text: " "),
                    TextSpan(
                      text: "oturum açiniz",
                      style: TextStyle(
                        color: Color.fromARGB(240, 102, 50, 142),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              emailBox("Email", Icons.mail, "E-posta adresi", emailWidth),
              SizedBox(height: 3,),
              passwordBox("Şifre", Icons.lock, "Şifre", passwordWidth),
              Container(
                width: 325,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          side: BorderSide(
                            color: const Color.fromARGB(240, 102, 50, 142),
                          ),
                          value: rememberUser,
                          onChanged: (value) {
                            setState(() {
                              rememberUser = value ?? false;
                            });
                          },
                        ),
                        Text(
                          "Beni hatirla",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(240, 102, 50, 142),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      hoverColor: Colors.transparent,
                      splashColor: Color.fromARGB(255, 251, 251, 251),
                      highlightColor: Color.fromARGB(255, 251, 251, 251),
                      onTap: () {
                        GoRouter.of(context).push("/resetPass");
                      },
                      child: Text(
                        "Şifremi Unuttum",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(240, 102, 50, 142),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Color.fromARGB(255, 251, 251, 251),
                highlightColor: Color.fromARGB(255, 251, 251, 251),
                onTap: () {
                  if (isEmailEmpty == false && isPasswordEmpty == false) {
                    if (emailFormat == true) {
                      login();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Email formatiniz yanliş, lütfen kontrol ediniz"),
                        backgroundColor: Colors.red.shade300,
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Lütfen ilgili alanlari doldurunuz"),
                      backgroundColor: Colors.red.shade300,
                      behavior: SnackBarBehavior.fixed,
                    ));
                  }
                },
                child: Container(
                  width: buttonWidth,
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 13),
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 156, 124, 249),
                        const Color.fromARGB(255, 127, 85, 247),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Giriş Yap",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Hesabin yok mu?",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    TextSpan(text: " "),
                    TextSpan(
                      text: "Şimdi kayit ol",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          GoRouter.of(context).replace("/register");
                        },
                      style: TextStyle(
                        color: Color.fromARGB(240, 102, 50, 142),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: 325,
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(136, 155, 155, 155),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Veya",
                      style: TextStyle(
                        fontSize: 10,
                        color: const Color.fromARGB(136, 155, 155, 155),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Divider(
                        color: const Color.fromARGB(136, 155, 155, 155),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 249, 249, 253),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Color.fromARGB(255, 230, 233, 246),
                    ),
                  ),
                  child: Image.asset(
                    "assets/images/googleLogo.png",
                    width: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget passwordBox(String name, IconData icon, String hint, double width) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: switchChange
                  ? Colors.white
                  : Color.fromARGB(255, 102, 50, 142),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: switchChange
                    ? Colors.white
                    : const Color.fromARGB(246, 102, 50, 142),
              ),
            ),
            width: width,
            height: 50,
            child: Container(
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: switchChange
                        ? Colors.black87
                        : const Color.fromARGB(245, 102, 50, 142),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            isPasswordEmpty = true;
                          });
                        }
                        else {
                          setState(() {
                            isPasswordEmpty = false;
                          });
                        }
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        suffixIcon: IconButton(
                          icon: passwordVisible
                              ? Icon(Icons.visibility_off, size: 20)
                              : Icon(Icons.visibility, size: 20),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
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
                      obscureText: passwordVisible,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailBox(String name, IconData icon, String hint, double width) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: switchChange
                  ? Colors.white
                  : Color.fromARGB(255, 102, 50, 142),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: switchChange
                    ? Colors.white
                    : const Color.fromARGB(246, 102, 50, 142),
              ),
            ),
            width: width,
            height: 50,
            child: Container(
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: switchChange
                        ? Colors.black87
                        : const Color.fromARGB(245, 102, 50, 142),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          setState(() {
                            emailFormat = true;
                            isEmailEmpty = false;
                          });
                        } 
                        else if (value.isEmpty) {
                          setState(() {
                            isEmailEmpty = true;
                          });
                        } 
                        else {
                          setState(() {
                            emailFormat = false;
                            isEmailEmpty = false;
                          });
                        }
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: hint,
                        hintStyle: TextStyle(
                          color: Colors.grey,
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
            ),
          ),
        ],
      ),
    );
  }
}
