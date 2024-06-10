import 'package:flutter/material.dart';
import "navdraw.dart";
class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      drawer:NavDrawer(),
      body: Center(
        child: Text('This is the second page'),
      ),
    );
  }
}