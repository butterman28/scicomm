import 'package:flutter/material.dart';
import 'jwt.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:provider/provider.dart';
//var x = Post.comments;

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String postText = '';
  String? _image;
  final picker = ImagePicker();
  List<int>? imageBytes;

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

  Future<dynamic> sendpost() async {
    String? access1 = await AuthService.getAccessToken();
    String base64Image;
    Map<String, dynamic> newcomm = {};
    if (_image != null) {
      FileSystemEntity file = File(_image!);
      // Read image file if _image is not null
      //imageBytes = File(_image!).readAsBytesSync();
      //imageBytes = await (file as File).readAsBytes();
      //imageBytes = await (file as File).readAsBytes();
      base64Image = base64Encode(imageBytes!);
      //print(base64Image);
      const url = 'http://127.0.0.1:8000/blog/post/';      
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'title': _titleController.text,
          'content': _contentController.text,
          'image': base64Image,
          // You can include additional fields as needed
          }),
        headers: {
          'Authorization': 'Bearer $access1', 
          'Content-Type': 'application/json',
        },
      );
      
      
      if (response.statusCode == 201) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        //final likemessage = responseBody['message'];
        newcomm = responseBody['data'];
        print(newcomm);
       // Navigator.push(
         // context,
          //MaterialPageRoute(builder: (context) => LoginScreen()),
          //);
      // User registration successful
      // Upload image if available
      //if (_image != null) {
      // Code to upload image to server
      // You can use packages like http or Dio for image uploa
      //http.post(Uri.parse(url), body: {'image': _image});
        print('User registered successfully');
        return newcomm;
      }
      else {
      // User registration failed
          print("after");
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['data'];
          print('Registration failed: $responseData');
          return newcomm;
      }
    }
    else {
      return newcomm;
      // Handle the case when _image is null
      print('Error: _image is null');
    }
  
    // Navigate to login page or do something else

    
  }

  void _updatePostText(String newText) {
    setState(() {
      postText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'titile?',
                border: OutlineInputBorder(),
              ),
              //onChanged: _updatePostText,
              maxLines: 1,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'content',
                border: OutlineInputBorder(),
              ),
              //onChanged: _updatePostText,
              maxLines: 5,
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

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()async  {
                Map<String, dynamic> ncomm = await sendpost();
                //addPost(ncomm);
                Provider.of<PostProvider>(context, listen: false).addPost(ncomm);
                // Here you could handle posting the text
                _showPostConfirmation(postText);
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostConfirmation(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Post Created'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
