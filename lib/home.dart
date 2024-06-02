import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Post {
  final int id;
  final String title;
  final String content;
  final String? base64Image; // Define base64Image property
  int likes;
  List<String> comments;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.base64Image, // Update constructor
    required this.likes,
    required this.comments,
  });
}

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

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('YOUR_API_ENDPOINT_HERE'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((postJson) {
        return Post(
          id: postJson['id'],
          title: postJson['title'],
          content: postJson['content'],
          base64Image: postJson['image'], // Assuming 'image' field contains base64 image
          likes: postJson['likes'],
          comments: List<String>.from(postJson['comments']),
        );
      }).toList();
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
                return ListTile(
                  title: Text(post.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.content),
                      SizedBox(height: 8),
                      Text('Likes: ${post.likes}'),
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
                  trailing: IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {
                      // Implement like functionality
                    },
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