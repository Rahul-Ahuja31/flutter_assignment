

import 'package:flutter_assignment/model/api_response.dart';
import 'package:flutter_assignment/model/posts_model.dart';

abstract class PostRepository {
  Future<ApiResponse<List<PostsModel>>> getPosts();
  Future<ApiResponse<List<PostsModel>>> getFavouritePosts();
}