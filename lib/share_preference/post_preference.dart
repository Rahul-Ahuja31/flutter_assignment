import 'dart:convert';

import 'package:flutter_assignment/model/posts_model.dart';
import 'package:flutter_assignment/share_preference/base_preference.dart';

class PostPreference extends BasePreference {
  static const String _preferenceName = "post_preference";
  static const String _favouritePosts = "favourite_posts";

  PostPreference._internal() : super(_preferenceName);

  static final PostPreference _instance = PostPreference._internal();

  factory PostPreference() => _instance;

  Future<List<PostsModel>> getFavouritePost() async {
    String postString= await super.readData(key: _favouritePosts) ?? "";

    if(postString.isEmpty) {
      return [];
    }

    List<dynamic> posts = jsonDecode(postString);
    return posts.map((e) => PostsModel.fromJson(e)).toList();
  }

  Future<void> addToFavourite(PostsModel post) async {
    List<PostsModel> posts = await getFavouritePost();
    posts.add(post);
    await super.saveData(key: _favouritePosts, value: jsonEncode(posts));
  }


  Future<void> removeFromFavourite(PostsModel post) async {
    List<PostsModel> posts = await getFavouritePost();
    posts.removeWhere((element) => element.id == post.id);
    await super.saveData(key: _favouritePosts, value: jsonEncode(posts));
  }

  Future<bool> isFavourite(int id) async {
    List<PostsModel> posts = await getFavouritePost();
    return posts.any((element) => element.id == id);
  }


}
