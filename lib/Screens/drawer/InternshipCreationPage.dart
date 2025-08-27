import 'package:flutter/material.dart';

import '../../widget/customroundedappbar.dart';

class InternshipCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customRoundedAppBar(context, 'Post Internship'),
      body: Center(child: Text('Internship Creation Page')),
    );
  }
}

