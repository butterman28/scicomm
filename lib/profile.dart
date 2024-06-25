import 'package:flutter/material.dart';
import 'dart:typed_data';
import "jwt.dart";
import "navdraw.dart";
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "userdetails.dart";
import "user_reg.dart";
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import  "navdraw.dart";
class Profile extends StatefulWidget {
  @override
  _EditableFormState createState() => _EditableFormState();
}
class _EditableFormState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController dobController = TextEditingController();

String? age;
String proimage ='';
List<String?> userdata = [];
String base64Image = "";
String? _image;
final picker = ImagePicker();
List<int>? imageBytes;
//Uint8List bytes = ;
  // Function to fetch data from API
  Future<void> fetchData() async {
    print("Help");
    Future<List<String?>> futureUserData = Future.delayed(Duration(seconds: 0), () {
      return welcomeuser(); // Example data
    });
    futureUserData.then((userData) {
      setState(() {
        // Update userdata with the fetched data
        userdata = userData;
        print(userdata);
        // Update the text controllers with the fetched data or "unknown" if data is null
        nameController.text = userdata[0] ?? "unknown";
        emailController.text = userdata[1] ?? "unknown";
        proimage = userdata[2] ?? "unknown";
        ageController.text = userdata[3] ?? "unknown";
        dobController.text = userdata[4] ?? "unknown";
      });
    }).catchError((error) {
      // Handle errors if any
      print("Error: $error");
    });
    }
  void _submitForm() async {
    if (imageBytes != null){
      base64Image = base64Encode(imageBytes!);

    }  
  print(3);
  //var requestBody ;
  var data;
  // Construct the request body
  if (base64Image == ""){
    data = jsonEncode({
    'name': nameController.text,
    'email': emailController.text,
    'age': ageController.text,
    'dob': dobController.text,
    //'image': base64Image,
    // Add more fields as needed
  });
  print(data);
  print(1);
  }else{
    data = jsonEncode({
    'name': nameController.text,
    'email': emailController.text,
    'age': ageController.text,
    'dob': dobController.text,
    'image': base64Image,
    // Add more fields as needed
  });
  print(data);
  print(2);
  }
  //requestBody = data;
  // API endpoint URL
  String? username1 = await getUsername();
  String? access1 = await AuthService.getAccessToken();
  var url = Uri.parse('http://127.0.0.1:8000/users/profile/$username1/');
  // Send POST request
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $access1',
    },
    body:data,
  );

  // Check if the request was successful
  if (response.statusCode == 200) {
    // If successful, print response body
    print('API Response: ${response.body}');
    if (base64Image != ""){
      await saveimagelocal(base64Image);
      var setimage = await getproimage(); 
      setState(() {
        proimage = setimage ?? "unknown";
        _image = null;
      });
      }else {
        await saveimagelocal(base64Image);
        var setimage = await getproimage(); 
        setState(() {
            _image = null;
    });

      }
    // You can add further logic here based on your API response
  } else {
    // If unsuccessful, print error message
    print('Failed to send data. Error: ${response.statusCode}');
    // Handle error state in your UI as needed
  }
}
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
          //print(_image);
          //print(1);
        } else {
          _image = pickedFile.path;
          //print(_image);
          //print(2);
        }
        //_image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      drawer: NavDrawer(),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.memory(
              base64Decode(proimage),
              width: 100, // Adjust width as needed
              height: 100, // Adjust height as needed
            ),
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
                child: Text('Change Profile Picture'),
              ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'age'),
            ),
            TextField(
              controller: dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),

            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _submitForm();
                // Handle form submission here
                // For example, you can send the data back to the API for update
                print('Name: ${nameController.text}');
                print('Email: ${emailController.text}');
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
    
  }
}