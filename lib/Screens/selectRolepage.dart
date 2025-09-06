import 'package:armii_recruiter_app/Auth/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class SelectRolePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                "Select Your Role",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // White title
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Recruiter Card
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Container(
                  width: screenWidth * 0.9,
                  padding: EdgeInsets.symmetric( vertical:  screenHeight * 0.06,),
                  decoration: BoxDecoration(
                    color: Colors.white, // White box
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      "I am Recruiter / Hirer",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.black, // Black text
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Candidate Card
              GestureDetector(
                onTap: () {
                  // Example: increment counter in AppState when candidate is selected
                  context.read<AppState>().increment();
                  print('Candidate selected, counter: '
                    '${context.read<AppState>().counter}');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => CandidatePage()),
                  // );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.06,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      "I am Candidate",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18, // or use screenWidth * 0.045 if you want to keep it responsive
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}