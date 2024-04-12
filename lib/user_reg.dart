import 'dart:io';
import 'package:flutter/material.dart';
import 'userlogin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (kIsWeb) {
          //_image = Image.network(pickedFile.path);
          _image = File(pickedFile.path);
        } else {
          _image = File(pickedFile.path);
        }
        //_image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _registerUser() async {
    final url =
        'http://127.0.0.1:8000/users/register/'; // Replace with your Django server URL
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'age': _ageController.text,
        //'image': _image
        // You can include additional fields as needed
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      // User registration successful
      // Upload image if available
      //if (_image != null) {
      // Code to upload image to server
      // You can use packages like http or Dio for image uploa
      //http.post(Uri.parse(url), body: {'image': _image});
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      print('User registered successfully');
    }
    // Navigate to login page or do something else

    else {
      // User registration failed
      final responseData = jsonDecode(response.body);
      final errorMessage = responseData['error'];
      print('Registration failed: $errorMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 12),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12),
              _image != null
                  ? kIsWeb
                      ? Image.network(_image!.path,
                          height: 100, width: 100, fit: BoxFit.cover)
                      : Image.file(_image!,
                          height: 100, width: 100, fit: BoxFit.cover)
                  : Text(
                      'No image selected'), // Display a message if no image is selected
              ElevatedButton(
                onPressed: _getImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
