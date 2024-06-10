import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  int? value;
  String? idUser, userName, email, address;

  Future<void> saveSession(
      int val, String id, String userName, String email, String address) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("value", val);
    pref.setString("id", id);
    pref.setString("username", userName);
    pref.setString("email", email);
    pref.setString("address", address);
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("value");
    pref.getString("id");
    pref.getString("username");
    pref.getString("email");
    pref.getString("address");
    return value;
  }

  Future getSesiIdUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getString("id");
    return idUser;
  }

  Future<void> updateUsername(String newUsername) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("username", newUsername);
  }

  Future<void> updateEmail(String newEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("email", newEmail);
  }

  Future<void> updateAddress(String newAddress) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("address", newAddress);
  }

  //clear session --> logout
  Future clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

SessionManager session = SessionManager();
