import 'package:flutter/material.dart';
import 'package:flutter_assignment/model/posts_model.dart';

class PostDetailScreen extends StatelessWidget {
  final PostsModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(text: "Title : ", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(text: post.title, style: Theme.of(context).textTheme.bodyLarge),
              ]),
            ),
            const SizedBox(height: 10),
            Text(
              "Description : ",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(post.body ?? ""),
          ],
        ),
      ),
    );
  }
}
