import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'home.dart';
//import "post.dart";

class PostProvider extends ChangeNotifier {
  List<dynamic> _posts = [];
  List<Post> posts1 = [];
  List<Post> postcate = [];
  String category = "Agriculture";

  List<dynamic> get posts => _posts;
  //String _category = '';

  //String get category => _category;
  //PostProvider({this.category = "Agriculture"});

  String changecategory(String newcat) {
    category = newcat;
    //print(category);
    notifyListeners();
    return category; // Notify listeners about the change
  }

  String fecthposttoseive(List<Post> poststoseive) {
    posts1 = poststoseive;
    //print(category);
    notifyListeners();
    return category; // Notify listeners about the change
  }

  void fetchpostbasedoncategory(String newcat) {
    postcate = posts1.where((posts1) => posts1.category == category).toList();
    //print(category);
    notifyListeners();
    //return postcate; // Notify listeners about the change
  }

  String readcategory() {
    String categor = category;
    //print(category);
    notifyListeners();
    return categor; // Notify listeners about the change
  }

  void addPost(Map<String, dynamic> newPost) {
    posts.add(newPost);
    notifyListeners(); // Notify listeners that the list has changed
  }

  Future<String?> userdata() async {
    // String? access1 = await AuthService.getAccessToken();
    String? username = await getUsername();
    // After the values are fetched, print the welcome message
    return username;
  }

  void updateLikeStatus(int postId, bool isLiked) {
    // Find the post with the given postId
    Post post = _posts.firstWhere((post) => post.postId == postId);
    var usern = userdata();

    // Update like status
    //post.isLikedByUser() = isLiked;
    //if (isLiked) {
    //  icon
    //  } else {
    //post.likesCount--;
    //}

    // Notify listeners
    notifyListeners();
  }
}
