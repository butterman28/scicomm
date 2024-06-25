import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'jwt.dart';
import 'userdetails.dart';
import 'dart:typed_data';
import "navdraw.dart";
import "profile.dart";
class Post {
  final int id;
  final String title;
  final String content;
  final String? base64Image; // Define base64Image property
  List<dynamic> likes;
  List<dynamic> comments;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.base64Image, // Update constructor
    required this.likes,
    required this.comments,
  });
  bool isLikedByUser(String username) {
    for (var like in likes) {
      if (like['user']['username'] == username) {
        return true; // Username found in likes
      }
    }
    return false; // Username not found in likes
  }
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      base64Image: json['base64Image'],
      likes: json['likes'] ?? [], // Initialize with empty list if null
      comments: json['comments'] ?? [], // Initialize with empty list if null
    );
  }
  void deleteLikeByUsername(String username) {
    // Iterate through the likes list
    for (int i = 0; i < likes.length; i++) {
      // Check if the username matches
      if (likes[i]['user']['username'] == username) {
        print(likes[i]['user']['username']);
        // Remove the like entry
        likes.removeAt(i);
        print(likes);
        // Assuming you only want to remove one entry, break out of the loop
        break;
      }
    }
    }
}
String? username;
String? email;
String? proimage;
//var _likeColor;
Map<int, Color?> _likeColor = {};
Map<int, bool> likedPosts = {};
var color;

String welcome ="Welcome, $username";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = fetchPosts();

  }
  
  Future<List<String?>> welcomeuser() async {
   // String? access1 = await AuthService.getAccessToken();
    username = await getUsername();
    email = await getEmail();
    proimage = await getproimage();
    // After the values are fetched, print the welcome message
    return [username,email,proimage];
}
Future<Map<String, dynamic>> likeform(int postid ) async {
  //var likes;
  //String pid= "";
   var data = jsonEncode({
    'dostring': "like",
    // Add more fields as needed
  });
  String? access1 = await AuthService.getAccessToken();
  final url = Uri.parse('http://127.0.0.1:8000/blog/like/$postid/');
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $access1',
    },
    body:data,
  );
  
  final likemessage ;
  Map<String, dynamic> like = {};
   if (response.statusCode == 200 ) {
    Map<String, dynamic> responseBody = json.decode(response.body);
    final likemessage = responseBody['message'];
    //like = responseBody['data'];
    print('afterme');
    print(like);
    print('before');
    if (likemessage == "liked") {
      like = responseBody['data'];
      print('after');
      likedPosts[postid] = true; // Mark post as liked
      //post.likes.add(responseBody['data'])
    } else if (likemessage == "unliked") {
      likedPosts[postid] = false; // Mark post as unliked
    }
    return like;
 }else{
  return like;
 }
}
  Future<List<Post>> fetchPosts() async {
    String? access1 = await AuthService.getAccessToken();
    
    //print(username);
    print("welcome$username");
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/blog/post/'),
      headers: {
          'Authorization': 'Bearer $access1', 
          'Content-Type': 'application/json',
        },

      );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((postJson) {
        //print(access1);
        return Post(
          id: postJson['id'],
          title: postJson['title'],
          content: postJson['content'],
          base64Image: postJson['image'], // Assuming 'image' field contains base64 image
          likes: List<dynamic>.from(postJson['like']),
          comments: List<dynamic>.from(postJson['comments']),
        );
      }).toList();
      //print(access1);
    } else {
      throw Exception('Failed to load posts');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
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
            return ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: const Color(0xff764abc)),
                  accountName: snapshot.connectionState == ConnectionState.waiting
                  ? Text("Loading...") // Display loading indicator while waiting
                  : Text(username ?? "Unknown"), // Display username or "Unknown" if null
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
                  Icons.home,
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
                  Icons.train,
                ),
                title: const Text('Page 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              username != "Oluwadara"
              ? ListTile(
                leading: Icon(
                   Icons.home,
                ),
                title: const Text('Create A Post'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                
              )
              : SizedBox.shrink(),
        ]
      );
     }
    }
    ),
  ),    

      
      // Important: Remove any padding from the ListView.
       body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Post> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                print(post.likes);
                Color iconColor = post.isLikedByUser(username!) ? Colors.red : Colors.grey;
                return ListTile(
                  title: Text(post.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.content),
                      SizedBox(height: 8),
                      Text('Likes: ${post.likes.length}'),
                      SizedBox(height: 4),
                      Text('Comments: ${post.comments.length}'),
                    ],
                  ),
                  leading: post.base64Image != null
                      ? Image.memory(
                          base64Decode(post.base64Image!), // Decode base64 image
                          width: 50, // Adjust width as needed
                          height: 50, // Adjust height as needed
                          fit: BoxFit.cover,
                        )
                      : SizedBox.shrink(),
                  trailing:
                  //SizedBox(  // Example of using SizedBox to fix width
                  //width: 120, 
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min, // Align items to the end of the row
                  children: [
                  IconButton(
                    icon: Icon(Icons.favorite,color: _likeColor[post.id] = iconColor), 
                    //: icon: Icon(Icons.favorite,color: _likeColor[post.id]) ,
                    onPressed: () async {
                      Map<String, dynamic> like = await likeform(post.id);
                      //print(like);
                      if (post.isLikedByUser(username!)) {
                                post.deleteLikeByUsername(username!);
                                setState(() {
                                  iconColor = Colors.grey;
                                });
                                print(1); // Unlike the post
                           }
                           else{
                           if (like != {}){
                              setState(() {
                                iconColor = Colors.red;
                              });
                            post.likes.add(like);
                            print(2);
                            }}
                      // Implement like functionality
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.comment,color:Colors.blueAccent), 
                    //: icon: Icon(Icons.favorite,color: _likeColor[post.id]) ,
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                        return Container(
                        padding: EdgeInsets.all(16.0),
                          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Add a comment',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your comment',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                      ),
                      SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle saving the comment or any action
                            Navigator.pop(context); // Close the bottom sheet
                          },
                          child: Text('Post'),
                        ),
                      ),
                    ],
                  ),
                );
                }
                );  
                    }
                  )
                  
              ]
              
                  ),
              onTap: () {
                    // Navigate to post details page
                  },
              );
              },
            );
          }
        },
      ),
    );
  }
}