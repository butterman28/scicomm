import 'package:shared_preferences/shared_preferences.dart';

String? username;
String? email;
String? proimage;
String? age;
String? dob;

Future<void> saveUserDataLocally(String username, String email,String image,String age,String dob) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', username);
  prefs.setString('email', email);
  prefs.setString('profilephoto', image);
  prefs.setString('age', age);
  prefs.setString('dob', dob);
}
Future<void> saveimagelocal(String image,) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('profilephoto', image);
}
Future<String?> getUsername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

Future<String?> getEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}
Future<String?> getproimage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('profilephoto');
}
Future<String?> getage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('age');
}
Future<String?> getdob() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('dob');
}
Future<List<String?>> welcomeuser() async {
   // String? access1 = await AuthService.getAccessToken();
    username = await getUsername();
    email = await getEmail();
    proimage = await getproimage();
    age = await getage();
    dob = await getdob();

    // After the values are fetched, print the welcome message
    return [username,email,proimage,age,dob];
}
