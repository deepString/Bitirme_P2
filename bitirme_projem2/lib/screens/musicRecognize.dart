import 'package:avatar_glow/avatar_glow.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MusicRecognizeScreen extends StatefulWidget {
  const MusicRecognizeScreen({super.key});

  @override
  State<MusicRecognizeScreen> createState() => _MusicRecognizeScreenState();
}

class _MusicRecognizeScreenState extends State<MusicRecognizeScreen> {
  // API'den gelen metindeki ANSI renk kodlarını temizlemek için bir fonksiyon
  String removeAnsiCodes(String input) {
    // ANSI renk kodlarını temizleyen regex pattern
    final ansiEscape = RegExp(r'\x1B\[[0-9;]*m');
    return input.replaceAll(ansiEscape, '');
  }

  // Aşağıdaki değişken, şarkı adını saklamak için kullanılır.
  String firstPart = '';
  // Aşağıdaki değişken, AvatarGlow animasyonunu kontrol eder.
  bool glowAnimate = false;
  // Aşağıdaki değişken, API istediğini iptal etmek için kullanılır.
  CancelToken? cancelToken;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 37, 8, 58),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Color.fromARGB(220, 255, 255, 255),
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                "Şarkiyi Aramak İçin Tiklayiniz",
                style: TextStyle(
                  color: const Color.fromARGB(225, 255, 255, 255),
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              AvatarGlow(
                glowRadiusFactor: 0.7,
                glowColor: Color.fromARGB(255, 184, 32, 146),
                animate: glowAnimate,
                child: InkWell(
                  onTap: () {
                    if (glowAnimate == true) {
                      // Eğer şu anda dinliyorsa, iptal etmek için
                      cancelToken?.cancel("İptal Edildi");
                      setState(() {
                        glowAnimate = false; // Animasyonu durdurur
                      });
                    }
                    else {
                      // Şarkıyı ara ve animasyonu başlat
                      cancelToken = CancelToken();
                      recognizeSong(cancelToken!);
                      setState(() {
                        glowAnimate = true; // Animasyonu başlat
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Material(
                    elevation: 8,
                    shape: CircleBorder(),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 43, 19, 61),
                            width: 11,
                          ),
                          shape: BoxShape.circle),
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 64, 34, 94),
                        child: SvgPicture.asset(
                          "assets/icons/search.svg",
                          height: 30,
                          colorFilter: ColorFilter.mode(
                              Color.fromARGB(255, 252, 7, 142),
                              BlendMode.srcIn),
                        ),
                        radius: 40,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sonuç",
                          style: TextStyle(
                              color: const Color.fromARGB(225, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 40),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(67, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              firstPart,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                color: Color.fromARGB(225, 255, 255, 255),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void recognizeSong(CancelToken cancelToken) async {
    try {
      var response = await Dio()
          .post('http://192.168.1.104:5000/recognize', data: {'seconds': 5}, cancelToken: cancelToken);

      if (response.statusCode == 200) {
        setState(() {
          firstPart = removeAnsiCodes(response.data['song_info']);
          glowAnimate = false; // Şarkıyı bulununca animasyonu durdurur
        });
      } else {
        print('Error with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        print("İstek iptal edildi: $e");
      }
      else {
        print('Error: $e');
      }
      setState(() {
        firstPart = 'Arama iptal edildi';
        glowAnimate = false;  // Hata oluştu, animasyonu durdur.
      });
    }
  }
}
