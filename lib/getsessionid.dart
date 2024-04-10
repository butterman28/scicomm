import 'package:shared_preferences/shared_preferences.dart';

Future<String> getSessionId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('session_id') ?? '';
}
