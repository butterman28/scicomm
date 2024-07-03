import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'jwt.dart';
import 'userdetails.dart';
import 'dart:typed_data';
import "navdraw.dart";
import "profile.dart";
import 'createpost.dart';
import 'userlogin.dart';
import 'postdetails.dart';

Future<void> deleteThings() async {
  await AuthService.deleteTokens();
  await deleteUserDataLocally();
}

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

  bool iscommentexisting(String username) {
    for (var comment in comments) {
      if (comment['author']['username'] == username) {
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

  void deletecommentByid(int id) {
    // Iterate through the likes list
    for (int i = 0; i < comments.length; i++) {
      // Check if the username matches
      if (comments[i]['id'] == id) {
        //print(comments[i]['id']);
        // Remove the like entry
        comments.removeAt(i);
        //print(comments);
        // Assuming you only want to remove one entry, break out of the loop
        break;
      }
    }
  }
}

class PostProvider extends ChangeNotifier {
  List<dynamic> _posts = [];

  List<dynamic> get posts => _posts;

  void addPost(Map<String, dynamic> newPost) {
    posts.add(newPost);
    notifyListeners(); // Notify listeners that the list has changed
  }
}

String? username;
String? email;
String? proimage;
bool editit = false;
var commentid;
//var _likeColor;
Map<int, Color?> _likeColor = {};
Map<int, bool> likedPosts = {};
var color;
List<Post> posts = [];
//var post;
String welcome = "Welcome, $username";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Post>> _postsFuture;
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _postsFuture = fetchPosts();
  }

  void addPost(Post newPost) {
    setState(() {
      posts.add(newPost);
    });
  }

  Future<void> deleteThings() async {
    await AuthService.deleteTokens();
    await deleteUserDataLocally();
  }

  Future<List<String?>> welcomeuser() async {
    // String? access1 = await AuthService.getAccessToken();
    username = await getUsername();
    email = await getEmail();
    proimage = await getproimage();
    // After the values are fetched, print the welcome message
    return [username, email, proimage];
  }

  Future<Map<String, dynamic>> commentform(int postid, String content) async {
    var data = jsonEncode({
      'content': content,
      // Add more fields as needed
    });
    String? access1 = await AuthService.getAccessToken();
    final url = Uri.parse('http://127.0.0.1:8000/blog/comment/$postid/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $access1',
      },
      body: data,
    );
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, dynamic> comment = {};
    if (response.statusCode == 201) {
      comment = responseBody['data'];
    } else {
      comment = {};
    }
    return comment;
  }

  Future<Map<String, dynamic>> commentedit(
      int commentid, String content) async {
    var data = jsonEncode({
      'content': content,
      // Add more fields as needed
    });
    String? access1 = await AuthService.getAccessToken();
    final url =
        Uri.parse('http://127.0.0.1:8000/blog/commentadjust/$commentid/');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $access1',
      },
      body: data,
    );
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, dynamic> comment = {};
    if (response.statusCode == 200) {
      comment = responseBody['data'];
      print(comment);
    } else {
      comment = {};
    }
    return comment;
  }

  Future<bool> deletecommentform(int commentid) async {
    String? access1 = await AuthService.getAccessToken();
    final url =
        Uri.parse('http://127.0.0.1:8000/blog/commentadjust/$commentid/');
    final response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $access1',
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> likeform(int postid) async {
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
      body: data,
    );

    final likemessage;
    Map<String, dynamic> like = {};
    if (response.statusCode == 200) {
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
    } else {
      return like;
    }
  }

  Future<List<Post>> fetchPosts() async {
    String? access1 = await AuthService.getAccessToken();

    //print(username);
    //print("welcome$username");
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
          base64Image:
              postJson['image'], // Assuming 'image' field contains base64 image
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
            posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                print(post.likes);
                Color iconColor =
                    post.isLikedByUser(username!) ? Colors.red : Colors.grey;
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
                          base64Decode(
                              post.base64Image!), // Decode base64 image
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
                          mainAxisSize: MainAxisSize
                              .min, // Align items to the end of the row
                          children: [
                        IconButton(
                          icon: Icon(Icons.favorite,
                              color: _likeColor[post.id] = iconColor),
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
                            } else {
                              if (like != {}) {
                                setState(() {
                                  iconColor = Colors.red;
                                });
                                post.likes.add(like);
                                print(2);
                              }
                            }
                            // Implement like functionality
                          },
                        ),
                        IconButton(
                            icon: Icon(Icons.comment, color: Colors.blueAccent),
                            //: icon: Icon(Icons.favorite,color: _likeColor[post.id]) ,
                            onPressed: () async {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Container(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount:
                                                      post.comments.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    //final post = posts[index];
                                                    final comments =
                                                        post.comments[index];
                                                    //print(comments);
                                                    //print(post.likes);
                                                    Color iconColor =
                                                        post.isLikedByUser(
                                                                username!)
                                                            ? Colors.red
                                                            : Colors.grey;
                                                    //for (var i = 0; i < comments.length; i++) {
                                                    //print
                                                    //var comment = comments[i];
                                                    //if (post.iscommentexisting(comments["author"]["username"])){

                                                    return ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundImage: MemoryImage(
                                                            base64Decode(comments[
                                                                        "author"]
                                                                    ['profile']
                                                                ['image'])),
                                                        //child: Text('${index + 1}'),
                                                      ),
                                                      title: Text(
                                                          comments["content"]),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          //Text(post.content),
                                                          SizedBox(height: 8),
                                                          Text(
                                                              'Created At: ${comments["created_at"]}'),
                                                          SizedBox(height: 4),
                                                          Text(
                                                              'By: ${comments["author"]['username']}'),
                                                        ],
                                                      ),
                                                      //Text(comments["created_at"]),
                                                      trailing: username! ==
                                                              comments["author"]
                                                                  ["username"]
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min, // Align items to the end of the row
                                                              children: [
                                                                  IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color: Colors
                                                                              .red),
                                                                      onPressed:
                                                                          () async {
                                                                        bool
                                                                            status =
                                                                            await deletecommentform(comments["id"]);
                                                                        //print(status);
                                                                        if (status ==
                                                                            true) {
                                                                          setState(
                                                                              () {
                                                                            //print('Before deletion: ${post.comments}');
                                                                            post.deletecommentByid(comments["id"]);
                                                                            //print('after deletion: ${post.comments}');
                                                                            //comments = post.comments;
                                                                          });
                                                                        }
                                                                        //print(comments);
                                                                      }),
                                                                  IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color: Colors
                                                                              .grey),
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _commentController.text =
                                                                              comments["content"];
                                                                          editit =
                                                                              true;
                                                                          commentid =
                                                                              comments["id"];
                                                                        });
                                                                      })
                                                                ])
                                                          : SizedBox.shrink(),
                                                    );
                                                  }),
                                            ),
                                            Text(
                                              'Add a comment',
                                              style: TextStyle(fontSize: 18.0),
                                            ),
                                            SizedBox(height: 10.0),
                                            TextField(
                                              controller: _commentController,
                                              decoration: InputDecoration(
                                                hintText: 'Enter your comment',
                                                border: OutlineInputBorder(),
                                              ),
                                              maxLines: 1,
                                              keyboardType:
                                                  TextInputType.multiline,
                                            ),
                                            SizedBox(height: 10.0),
                                            Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: editit == false
                                                    ? ElevatedButton(
                                                        onPressed: () async {
                                                          Map<String, dynamic>
                                                              newcomment =
                                                              await commentform(
                                                                  post.id,
                                                                  _commentController
                                                                      .text);
                                                          print(newcomment);
                                                          if (newcomment !=
                                                              {}) {
                                                            setState(() {
                                                              post.comments.add(
                                                                  newcomment);
                                                              _commentController
                                                                  .text = "";
                                                            });
                                                          }

                                                          // Handle saving the comment or any action
                                                          //Navigator.pop(context); // Close the bottom sheet
                                                        },
                                                        child: Text('Post'),
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Align items to the end of the row
                                                        children: [
                                                            ElevatedButton(
                                                              // icon: Icon(Icons.close, color: Colors.grey),
                                                              onPressed: () {
                                                                setState(() {
                                                                  editit =
                                                                      false;
                                                                  _commentController
                                                                      .text = "";
                                                                });
                                                              },
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <Widget>[
                                                                  Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .red),
                                                                  SizedBox(
                                                                      width:
                                                                          8.0), // Adjust spacing as needed
                                                                  Text(
                                                                      'cancel'),
                                                                ],
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                Map<String,
                                                                        dynamic>
                                                                    newcomment =
                                                                    await commentedit(
                                                                        commentid,
                                                                        _commentController
                                                                            .text);
                                                                print(
                                                                    newcomment);
                                                                if (newcomment !=
                                                                    {}) {
                                                                  setState(() {
                                                                    post.deletecommentByid(
                                                                        commentid);
                                                                    post.comments
                                                                        .add(
                                                                            newcomment);
                                                                    _commentController
                                                                        .text = "";
                                                                    editit =
                                                                        false;
                                                                  });
                                                                }

                                                                // Handle saving the comment or any action
                                                                //Navigator.pop(context); // Close the bottom sheet
                                                              },
                                                              child:
                                                                  Text('edit'),
                                                            ),
                                                          ])),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            })
                      ]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(
                          post: post,
                        ),
                      ),
                    );
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
