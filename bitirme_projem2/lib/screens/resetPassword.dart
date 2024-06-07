import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 251, 251, 251),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 40, bottom: 16),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Parola Sifirlama",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 425,
                  child: Text(
                    "Kaydolmak için kulladiğin e-posta adresini gir. Parolani sifirlamak için kullanacağin bağlantiyi içeren bir e-posta göndereceğiz",
                    style: TextStyle(
                      color: Color.fromARGB(255, 133, 133, 133),
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 102, 50, 142),
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
                            color: const Color.fromARGB(246, 102, 50, 142),
                          ),
                        ),
                        width: 325,
                        height: 50,
                        child: Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.mail,
                                size: 20,
                                color: const Color.fromARGB(245, 102, 50, 142),
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "E-posta adresi",
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
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Color.fromARGB(255, 251, 251, 251),
                  highlightColor: Color.fromARGB(255, 251, 251, 251),
                  onTap: () {
                    GoRouter.of(context).replace("/changePass");
                  },
                  child: Container(
                    width: 300,
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
                          "Gönder",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
