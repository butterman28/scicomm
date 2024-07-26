class Post {
  final int id;
  final String title;
  final String content;
  final String category;
  final String? base64Image; // Define base64Image property
  List<dynamic> likes;
  List<dynamic> comments;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
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
      category: json['category'],
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
