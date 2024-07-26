//import 'package:flutter/material.dart';
//import 'storesessionid.dart';
import 'package:http/http.dart' as http;

Future<void> authenticateUser(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/users/login/'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Successful authentication, handle session ID or token
      // Extract session ID or token from response and store locally
      // For example:
      final sessionId = response.headers['session_id'];
      if (sessionId != null) {
        //storeSessionId(sessionId);
        print('Authentication successful!');
      } else {
        print('something is wrong ');
      }
    } else {
      // Handle authentication failure
      print('Authentication failed: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network errors or other exceptions
    print('Error during authentication: $e');
  }
}
