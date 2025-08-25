import 'package:flutter/material.dart';

class ObservePage extends StatefulWidget {
  @override
  _ObservePageState createState() => _ObservePageState();
}

class _ObservePageState extends State<ObservePage> {
  int selectedIndex = 0;

  final List<String> titles = [
    'Saved By Candidates',
    'Viewed by Candidates',
    'Shortlisted Candidates',
    'Hired Candidates',
    'Rejected Candidates',
  ];

  final List<String> descriptions = [
    "This section allows the user to check which applicant has saved any Job Role which are posted by the Recruiter.",
    "This section allows the user to check which applicant has viewed any Job Role which are posted by the Recruiter.",
    "This section allows the user to check the list of candidates whom the user has Shortlisted.",
    "This section allows the user to check the list of candidates whom the user has Hired.",
    "This section allows the user to check the list of candidates whom the user has Rejected.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(titles.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      width: 160, // Fixed width for better readability
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: selectedIndex == index ? Colors.blue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          titles[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedIndex == index ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              descriptions[selectedIndex],
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
