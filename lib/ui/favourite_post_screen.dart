import 'package:flutter/material.dart';
import 'package:flutter_assignment/model/api_response.dart';
import 'package:flutter_assignment/model/posts_model.dart';
import 'package:flutter_assignment/network/repository/post_repository_impl.dart';
import 'package:flutter_assignment/widgets/post_card_view.dart';

class FavouritePostScreen extends StatefulWidget {
  const FavouritePostScreen({super.key});

  @override
  State<FavouritePostScreen> createState() => _FavouritePostScreenState();
}

class _FavouritePostScreenState extends State<FavouritePostScreen> {
  final PostRepositoryImpl _postRepositoryImpl = PostRepositoryImpl();
  late Future<void> _getData;
  List<PostsModel> _posts = [];

  Future<void> _getFavouritePosts() async {
    ApiResponse<List<PostsModel>> response = await _postRepositoryImpl.getFavouritePosts();
    if (response is Success<List<PostsModel>>) {
      _posts = response.data;
    } else {
      throw response;
    }
  }

  @override
  void initState() {
    super.initState();
    _getData  = _getFavouritePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Posts"),
        centerTitle: true,
      ),
      body: SafeArea(
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
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _getData = _getFavouritePosts();
                          });
                        },
                        child: const Text("Retry"))
                  ],
                ),
              );
            } else if (_posts.isNotEmpty) {
              return ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return PostCardView(post: _posts[index],canShowFavouriteIcon: false,);
                },
              );
            } else {
              return const Center(child: Text("There is no any favourite post available."));
            }
          },
        ),
      ),
    );
  }
}
