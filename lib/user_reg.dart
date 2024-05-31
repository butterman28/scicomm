//import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'userlogin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  
  //File? _image; // Define the variable outside of the conditional block
  //String? _imageUrl;
  String? _image;
  final picker = ImagePicker();
  List<int>? imageBytes;
  //Future<List<int>>? imageBytes;


  Future<void> _getImage() async {
    //final pickedImage = await ImagePickerWeb.pickImage(outputType: ImageType.bytes);
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    //final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    imageBytes =await pickedFile!.readAsBytes();
    setState(()  {
      if (pickedFile != null) {
        if (kIsWeb) {
          //_image = Image.network(pickedFile.path);
          //_image = File(pickedFile.path);
          _image = pickedFile.path;
          //imageBytes = pickedFile.readAsBytes();
          print(_image);
          print(1);
        } else {
          _image = pickedFile.path;
          print(_image);
          print(2);
        }
        //_image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  

  Future<void> _registerUser() async {
    String base64Image;
    if (_image != null) {
      FileSystemEntity file = File(_image!);
      print(_image);
      print("before");
      // Read image file if _image is not null
      //imageBytes = File(_image!).readAsBytesSync();
      //imageBytes = await (file as File).readAsBytes();
      //imageBytes = await (file as File).readAsBytes();
      base64Image = base64Encode(imageBytes!);
      const url = 'http://127.0.0.1:8000/users/signup/';
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'email': _emailController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          "profile": {
            'age': _ageController.text,
            'image': base64Image
            }
          // You can include additional fields as needed
          }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      //print(base64Image);
      //print("after");
      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          );
      // User registration successful
      // Upload image if available
      //if (_image != null) {
      // Code to upload image to server
      // You can use packages like http or Dio for image uploa
      //http.post(Uri.parse(url), body: {'image': _image});
        print('User registered successfully');
      }
      else {
      // User registration failed
           print("after");
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['data'];
          print('Registration failed: $responseData');
      }
    }
    else {
      // Handle the case when _image is null
      print('Error: _image is null');
    }
  
    // Navigate to login page or do something else

    
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
                      ? Image.network(_image!,
                          height: 100, width: 100, fit: BoxFit.cover)
                      : Image.file(File(_image!),
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
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
            // Navigate to the second page when the button is clicked
                },
                //onPressed: _registerUser,
                child: Text('Already have an account sign in '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
