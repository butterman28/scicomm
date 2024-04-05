import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(home: Home()),
  );
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
            onPressed:(){},
            child:Text("click me"),
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
class butter extends StatefulWidget {
  const butter({super.key});

  @override
  State<butter> createState() => _butterState();
}

class _butterState extends State<butter> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
