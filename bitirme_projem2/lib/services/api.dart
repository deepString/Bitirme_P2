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

}