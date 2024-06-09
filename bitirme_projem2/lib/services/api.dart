import 'package:dio/dio.dart';

class API {

  // Burada dio nesnesini oluşturduk, istek gönderip cevap almak için
  final dio = Dio();

  // Burası ana adresimiz. Her yerde tek tek yazmak yerine burada yani en dışta 1 kez yazdık
  final String baseUrl = "https://reqres.in/api";


  // Kayıtlı kullanıcıların giriş yapması için fonksiyon oluşturdum
  // Required yazarak mail ve şifreyi zorunlu tuttum
  loginUser({required String mail, required String passwords}) async {
    try {

      final String endUrl = "$baseUrl/register";

      final parameters = {
        "email": mail,  // eve.holt@reqres.in
        "password": passwords,  // pistol
      };

      final response = await dio.post(endUrl, data: parameters, options: Options(contentType: Headers.formUrlEncodedContentType));

      return response.data; // Map yapısı şeklinde döndürmesi için burada data yazdım
    }
    catch(e) {
      return e;
    }
  }

  registerUser({
    required String mail,  // eve.holt@reqres.in
    required String passwords,  // pistol
    }) async {
    try {

      final String endUrl = "$baseUrl/register";

      final parameters = {
        "email": mail,
        "password": passwords,
      };

      final response = await dio.post(endUrl, data: parameters, options: Options(contentType: Headers.formUrlEncodedContentType));

      return response.data; // Map yapısı şeklinde döndürmesi için burada data yazdım
    }
    catch(e) {
      return e;
    }
  }

  getStaticPage() async {
    return await Future.delayed(const Duration(milliseconds: 900), () {
      return {
        "splash": {
          "logo": "assets/images/logoApp.png",
          "backgroundColor": ["603565", "863dba"],
          "duration": 1500
        },
        "contact": {
          "githubLink": "https://github.com/deepString",
          "phones": "+901234567899"
        },
      };
    });
  }

  download(String path, String savePath) async {
    try {
    await dio.download(path, savePath);
    return true;
    }
    on Exception catch (e) {
      print("Bir hata oluştu");
      print(e);
      return null;
    }
  }

}