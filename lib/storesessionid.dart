import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeSessionId(String sessionId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('session_id', sessionId);
}
