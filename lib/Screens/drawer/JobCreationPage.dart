import 'package:flutter/material.dart';

import '../../widget/customroundedappbar.dart';

class JobCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customRoundedAppBar(context, 'Post Job'),
      body: Center(child: Text('Job Creation Page')),
    );
  }
}

