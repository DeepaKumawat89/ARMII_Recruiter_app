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
          // Horizontal chips row for section selection (matching HomePage style)
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(titles[index]),
                    selected: selectedIndex == index,
                    // selectedColor: Colors.indigo.shade100,
                    // backgroundColor: Colors.grey.shade200,
                    // labelStyle: TextStyle(
                    //   color: selectedIndex == index ? Colors.indigo : Colors.black87,
                    //   fontWeight: FontWeight.w600,
                    // ),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(20),
                    //   side: BorderSide(
                    //     color: selectedIndex == index ? Colors.indigo : Colors.transparent,
                    //     width: 2,
                    //   ),
                    // ),
                    onSelected: (_) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                );
              },
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
