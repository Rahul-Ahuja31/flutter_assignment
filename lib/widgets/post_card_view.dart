import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/model/posts_model.dart';
import 'package:flutter_assignment/share_preference/post_preference.dart';
import 'package:flutter_assignment/ui/post_detail_screen.dart';
import 'package:get/get.dart';

class PostCardView extends StatefulWidget {
  final PostsModel post;
  final bool canShowFavouriteIcon;

  const PostCardView({super.key, required this.post, this.canShowFavouriteIcon = true});

  @override
  State<PostCardView> createState() => _PostCardViewState();
}

class _PostCardViewState extends State<PostCardView> {

  RxBool _isFavourite = false.obs;

  PostPreference _postPreference = PostPreference();

  Future<void> _checkIsFavouritePost() async {
    _isFavourite.value = await _postPreference.isFavourite(widget.post.id ?? 0);
  }

  @override
  void initState() {
    super.initState();
    _checkIsFavouritePost();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: ListTile(
          onTap: () {
            Get.to(() => PostDetailScreen(post: widget.post));
          },
          title: Text(
            "${widget.post.title}",
            style: Theme
                .of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold,),
          ),
          subtitle: Text("${widget.post.body}", maxLines: 2,),
          trailing: Visibility(
            visible: widget.canShowFavouriteIcon,
            child: Obx(
                ()=> IconButton(
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  onPressed: () async {
                    if (_isFavourite.isTrue) {
                      await _postPreference.removeFromFavourite(widget.post);
                    } else {
                      await _postPreference.addToFavourite(widget.post);
                    }

                    await _checkIsFavouritePost();
                  }, icon: Icon(_isFavourite.isTrue ? Icons.bookmark : Icons.bookmark_border_rounded),

              ),
            ),
          ),
        ),
      ),
    );
  }
}
