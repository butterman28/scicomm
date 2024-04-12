import 'package:flutter/material.dart';
import 'storesessionid.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _authenticateUser(String username, String password) async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/users/csrf/'));

    // Extract the CSRF token from the response headers
    //String csrfToken = "";

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final csrfToken = data['csrf_token'];
      final response1 =
          await http.post(Uri.parse('http://127.0.0.1:8000/users/login/'),
              body: jsonEncode({
                'username': username,
                'password': password,
              }),
              headers: {
            'Content-Type': 'application/json',
            'Referer': 'http://localhost:62275',
            'X-CSRFToken':
                csrfToken, // Adjust this to your Flutter app's origin
          });
      if (response1.statusCode == 200) {
        // Successful authentication, handle session ID or token
        // Extract session ID or token from response and store locally
        // For example:
        final sessionId = response1.headers['session_id'];
        if (sessionId != null) {
          storeSessionId(sessionId);
          print('Authentication successful!');
        } else {
          print('something is wrong ');
        }
      } else {
        // Handle authentication failure
        print('Authentication failed: ${response1.statusCode}');
      }
    } else {
      // Handle error response
      //csrfToken = "";
    }
    // Your authenticateUser function implementation goes here...
    try {
      // print(csrfToken);
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error during authentication: $e');
    }
  }

  void _onLoginButtonPressed() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        await _authenticateUser(username, password);
        // Navigate to next screen upon successful authentication
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (e) {
        // Handle authentication error (e.g., show error message to user)
        print('Authentication failed: $e');
      }
    } else {
      // Show error message if username or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter username and password'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onLoginButtonPressed,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
