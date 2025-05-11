import 'dart:convert';
import 'package:flutter_assignment/model/api_response.dart';
import 'package:flutter_assignment/model/posts_model.dart';
import 'package:flutter_assignment/network/api_manager.dart';
import 'package:flutter_assignment/network/repository/post_repository.dart';
import 'package:flutter_assignment/share_preference/post_preference.dart';
import 'package:http/http.dart' as http;

class PostRepositoryImpl extends PostRepository {
  @override
  Future<ApiResponse<List<PostsModel>>> getPosts() async {
    try {
      final response = await http.get(Uri.parse(ApiManager.posts));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return Success(data.map((json) => PostsModel.fromJson(json)).toList());
      } else {
        return Error(response.statusCode, response.body);
      }
    } catch (e) {
      return Error(-1, e.toString());
    }
  }

  @override
  Future<ApiResponse<List<PostsModel>>> getFavouritePosts() async {
    try {
      return Success(await PostPreference().getFavouritePost());
    } catch (e) {
      return Error(-1, e.toString());
    }
  }
}
