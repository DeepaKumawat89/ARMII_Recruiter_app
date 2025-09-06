import 'package:flutter/material.dart';

class PostInternshipScreen extends StatelessWidget {
  const PostInternshipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post New Internship'),
      ),
      body: Center(
        child: Text('Internship Posting Form Will Go Here'),
      ),
    );
  }
}
