import 'package:flutter/material.dart';
import 'userdetails.dart';
import "profile.dart";
import 'dart:convert';
import 'dart:typed_data';
import 'home.dart';
import 'createpost.dart';
import 'user_reg.dart';
import 'userlogin.dart';
import "home.dart";

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<List<String?>>(
          future: welcomeuser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Display loading indicator while waiting
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Snapshot data is a list with the results of both futures
              final List<String?> data = snapshot.data!;
              final String username = data[0] ?? "Unknown";
              final String email = data[1] ?? "Unknown";
              final String proimage = data[2] ?? "Unknown";
              // Decoding base64 string into bytes
              Uint8List bytes = base64Decode(proimage);

              // Creating an image widget from the bytes
              Widget accountImage = Image.memory(
                bytes,
                width: 100, // Adjust width as needed
                height: 100, // Adjust height as needed
              );
              return ListView(children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: const Color(0xff764abc)),
                  accountName: snapshot.connectionState ==
                          ConnectionState.waiting
                      ? Text(
                          "Loading...") // Display loading indicator while waiting
                      : Text(username ??
                          "Unknown"), // Display username or "Unknown" if null
                  accountEmail: Text(
                    email,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  currentAccountPicture: accountImage,
                ),
// Other properties..
                ListTile(
                  leading: Icon(
                    Icons.person,
                  ),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                username != "Oluwadara"
                    ? ListTile(
                        leading: Icon(
                          Icons.publish,
                        ),
                        title: const Text('Create A Post'),
                        onTap: () {
                          Navigator.pop(context); // Close the drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreatePostPage()),
                          );
                        },
                      )
                    : SizedBox.shrink(),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                  ),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: const Text('Log-Out'),
                  onTap: () async {
                    await deleteThings();
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
                
              ]);
            }
          }),
    );
  }
}   
      // Important: Remove any padding from the ListView.
       