import 'package:flutter/material.dart';
import 'user_reg.dart';
import 'authenticateUser.dart';
import 'userlogin.dart';
import "home.dart";
import 'package:provider/provider.dart';
import 'postdetails.dart';
import 'package:daraweb/post_provider.dart';

void main() {
  runApp(
      //MaterialApp(home: RegistrationPage()),
      MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(
          create: (context) => PostProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //routes: {
        //'/home': (context) => HomePage(),
        //},
        home: LoginScreen(),
      ),
    );
  }
}
