import 'package:armii_recruiter_app/Screens/selectRolepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DashBoardScreens/HomePage.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class SplashScreen extends StatelessWidget {


  void _checkSessionAndNavigate(BuildContext context) async {
    Provider.of<AppState>(context, listen: false).increment();
    print('SplashScreen shown, counter incremented: '
      '${Provider.of<AppState>(context, listen: false).counter}');
    await Future.delayed(Duration(seconds: 3));
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SelectRolePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Future.microtask(() => _checkSessionAndNavigate(context));
    return Scaffold(
      body: Center(
        child: Text(
          "Splash Screen",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: screenWidth * 0.07,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
