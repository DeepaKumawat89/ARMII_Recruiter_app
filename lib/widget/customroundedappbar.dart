import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget customRoundedAppBar(BuildContext context, String title) {
  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: ClipRRect(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20), // round only bottom corners
      ),
      child: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 4,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    ),
  );
}

