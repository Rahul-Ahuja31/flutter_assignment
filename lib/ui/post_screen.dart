import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/model/api_response.dart';
import 'package:flutter_assignment/model/posts_model.dart';
import 'package:flutter_assignment/network/repository/post_repository_impl.dart';
import 'package:flutter_assignment/ui/favourite_post_screen.dart';
import 'package:flutter_assignment/widgets/post_card_view.dart';
import 'package:get/get.dart';


class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostRepositoryImpl _postRepositoryImpl = PostRepositoryImpl();
  late Future<void> _getData;
  List<PostsModel> _allPosts = [];
  final RxList<PostsModel> _posts = <PostsModel>[].obs;

  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        _posts.value = _allPosts;
      } else {
        _posts.value = _allPosts.where((element) => (element.title ?? "").toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  Future<void> _getPosts() async {
    ApiResponse<List<PostsModel>> response = await _postRepositoryImpl.getPosts();
    if (response is Success<List<PostsModel>>) {
      _allPosts = response.data;
      _posts.value = _allPosts;
    } else {
      throw response;
    }
  }

  @override
  void initState() {
    super.initState();
    _getData = _getPosts();
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            Get.to(()=> const FavouritePostScreen());
          }, icon: const Icon(Icons.star_border_outlined))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                // onChanged: _filterItems,
                decoration: InputDecoration(
                  hintText: 'Search by title...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.zero
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _getData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline_sharp),
                          const SizedBox(height: 10),
                          Text((snapshot.error as Error).message),
                          const SizedBox(height: 30),
                          ElevatedButton(onPressed: () {
                            setState(() {
                              _getData = _getPosts();
                            });
                          }, child: const Text("Retry"))
                        ],
                      ),
                    );
                  } else if (_posts.isNotEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async{
                        await _getPosts();
                      },
                      child: Obx(
                        ()=> ListView.builder(
                          itemCount: _posts.length,
                          itemBuilder: (context, index) {
                            return PostCardView(post: _posts[index]);
                          },
                        ),
                      ),
                    );
                  } else {
                    return const Text("There are no post available yet.");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
