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

  final List<List<String>> applicants = [
    ['John Doe', 'Jane Smith', 'Alice Johnson'],
    ['Michael Brown', 'Emily Davis', 'Chris Wilson'],
    ['Sophia Taylor', 'James Anderson', 'Olivia Thomas'],
    ['Liam Martinez', 'Emma Garcia', 'Noah Robinson'],
    ['Ava Clark', 'Ethan Lewis', 'Isabella Walker'],
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
                    label: Text(
                      titles[index],
                      style: TextStyle(fontFamily: 'Inter'),
                    ),
                    selected: selectedIndex == index,
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
          Expanded(
            child: PageView.builder(
              controller: PageController(initialPage: selectedIndex),
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: applicants[index]
                        .map((applicant) => Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  applicant,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
