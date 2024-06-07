import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  
  loadUser() async {

    SharedPreferences storage = await SharedPreferences.getInstance();
    var id = storage.getInt("Id");
    var name = storage.getString("Name");

    // id eğer boşsa yani null ise oturum yok demektir
    // Oturumun olup olmadığını aşağıda kontrol ettim
    if (id == null) {
      return null;
    }
    else {
      return {"Id": id, "Name": name};
    }
  }

  saveUser({
    required int id,
    required String name,
  }) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setInt("Id", id);
    storage.setString("Name", name);
  }

  // Aşağıdaki method kaydetmek için
  saveToken(String token) async {
    final storage = new FlutterSecureStorage();
    // SharedPreferences'te kaydetmek için set kullanmıştık. Burada ise write kullanıyoruz
    await storage.write(key: "token", value: token);
  }

  // Aşağıdaki method kaydettiğimiz bilgileri okumak için
  loadToken() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "token");
    return token;
  }

  clearUser() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final secureStorage = new FlutterSecureStorage();

    await storage.remove("Id");
    await storage.remove("Name");
    await secureStorage.delete(key: "token");
  }

  Future<bool> isFirstLaunch() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    final runned = storage.getBool("runned");

    if (runned == null) {
      return true;
    } 
    else {
      return false;
    }
  }

  firstLaunched() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setBool("runned", true);
  }

  setConfig({String? language, bool? darkMode}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    if (language != null) {
      await storage.setString("Language", language);
    }

    if (darkMode != null) {
      await storage.setBool("DarkMode", darkMode);
    }
  }

  getConfig() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    return {
      "Language": storage.getString("Language"),
      "DarkMode": storage.getBool("DarkMode"),
    };
  }

  clearStorage() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
  }

}