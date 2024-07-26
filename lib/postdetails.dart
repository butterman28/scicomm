import 'package:flutter/material.dart';
import 'home.dart';
import "jwt.dart";
import 'dart:convert';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'userdetails.dart';
//import 'home.dart';
import 'package:daraweb/home.dart' as home;

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

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final Future<void> Function() onRefresh;

  //const PostDetailScreen({required this.post});
  //PostDetailScreen(this.post);
  // ignore: use_super_parameters
  const PostDetailScreen(
      {Key? key, required this.post, required this.onRefresh})
      : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

Map<int, Color?> _likeColor = {};
Map<int, bool> likedPosts = {};

class _PostDetailScreenState extends State<PostDetailScreen> {
  void saveChangesAndPop(BuildContext context) {
    // Update the post object with changes and pop the page
    widget.post.likes;
    Navigator.pop(context, widget.post.likes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            if (mounted) {
              await widget.onRefresh();
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Post ID: ${widget.post.id}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.post.content,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite,
                      //color: widget.post.isLikedByUser(username!)
                      //    ? Colors.red
                      //    : null,
                      color: _likeColor[widget.post.id] =
                          widget.post.isLikedByUser(home.username!)
                              ? Colors.red
                              : Colors.grey),
                  onPressed: () async {
                    Map<String, dynamic> like = await likeform(widget.post.id);
                    //print(like);
                    if (widget.post.isLikedByUser(home.username!)) {
                      widget.post.deleteLikeByUsername(home.username!);
                      setState(() {
                        _likeColor[widget.post.id] = Colors.grey;
                      });
                      print(1); // Unlike the post
                    } else {
                      if (like != {}) {
                        setState(() {
                          _likeColor[widget.post.id] = Colors.red;
                        });
                        widget.post.likes.add(like);
                        print(2);
                      }
                    }
                    // Implement like functionality
                  },
                ),
                Text(
                  '${widget.post.likes.length} Likes',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
