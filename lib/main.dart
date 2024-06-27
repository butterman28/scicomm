import 'package:flutter/material.dart';
import 'user_reg.dart';
import 'authenticateUser.dart';
import 'userlogin.dart';
import "home.dart";
import 'package:provider/provider.dart';
void main() {
  runApp(
    //MaterialApp(home: RegistrationPage()),
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RegistrationPage(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "dara's app",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.grey[600],
            fontFamily: 'IndieFlower',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text("click me"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Button pressed!');
        },
        child: Text('click'),
      ),
    );
  }
}

class TextInputWiget extends StatefulWidget {
  const TextInputWiget({super.key});

  @override
  State<TextInputWiget> createState() => _TextInputWigetState();
}

class _TextInputWigetState extends State<TextInputWiget> {
  final controller = TextEditingController();
  //String text = "";
  //@override
  //void dispose() {
  //super.dispose();
  //controller.dispose();
  //}
  //void changeText(text){
  //setState(() {
  //this.text = text;
  //});
  //}

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: this.controller,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.message),
            labelText: "Enter A message or somesthing",
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              splashColor: Colors.blue,
              tooltip: "Send",
              onPressed: () => {},
            ))
        //onChanged: (text) => this.changeText(text),
        );
    //Text(this.text)
  }
}
