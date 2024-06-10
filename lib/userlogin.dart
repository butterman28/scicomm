import 'package:flutter/material.dart';
import 'storesessionid.dart';
import 'jwt.dart';
import 'userdetails.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'home.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<int> _authenticateUser(String username, String password) async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/users/login/'));

    // Extract the CSRF token from the response headers
    //var csrfToken = "";

    if (response.statusCode == 200) {
      final cookieHeader = response;
      print(response.body);
      //print(response.headers.keys.toList());
      //print(response.headers.values.toList());
      print(response.headers['set-cookie']);
      //String csr = csrfToken.toString();
      //print(csr);
      final response1 = await http.post(
        Uri.parse('http://127.0.0.1:8000/users/login/'),
        headers: {
          'Content-Type': 'application/json',
          //'Authorization':
          //'X-CSRFToken': csr,
        },
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
      );
      if (response1.statusCode == 200) {
        //print(response1.body);
        Map<String, dynamic> responseBody = json.decode(response1.body);
        final username = responseBody['username'];
        final email = responseBody['email'];
        final pro_image = responseBody['profilephoto'];
        await saveUserDataLocally(username, email, pro_image);
        String accessToken =responseBody['tokens']['access'];
        String refreshToken = responseBody['tokens']['refresh'];
        //print('Access Token: $accessToken');
        //print('Refresh Token: $refreshToken');
        await AuthService.saveTokens(accessToken, refreshToken);
        String? access1 = await AuthService.getAccessToken();
        return response1.statusCode;  
        //print(access1);
        // Successful authentication, handle session ID or token
        // Extract session ID or token from response and store locally
        // For example:
        //final sessionId = response1.headers['session_id'];
        //final accesstoken = response1.body
        //if (sessionId != null) {
          //storeSessionId(sessionId);
          //print('Authentication successful!');
        //} else {
          //print('something is wrong ');
        //}
      } else {
        // Handle authentication failure
        print('Authentication failed: ${response1.statusCode}');
        return response1.statusCode; 
      }
    } else {
      return -100; 
      // Handle error response
    }
    // Your authenticateUser function implementation goes here...

  }

  void _onLoginButtonPressed() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        int status = await _authenticateUser(username, password);
        if (status == 200){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            );
          }else{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );

          }
        // Navigate to next screen upon successful authentication
       
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
                labelText: 'Enter Email',
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
