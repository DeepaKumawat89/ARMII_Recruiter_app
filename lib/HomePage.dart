import 'package:flutter/material.dart';
import 'ObservePage.dart';
import 'ProfilePage.dart';
import 'auth_provider.dart' as my_auth;
import 'package:google_fonts/google_fonts.dart';
import 'ChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widget/CustomAppBar.dart';
import 'widget/CustomBottomNavBar.dart';
import 'widget/CustomDrawer.dart';
import 'widget/ApplicantCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class JobTitle {
  final String name;
  JobTitle(this.name);
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final my_auth.AuthProvider authProvider = my_auth.AuthProvider();
  Map<String, dynamic>? recruiterProfileData;
  bool isProfileLoading = true;
  String? profileErrorMsg;

  // Mock data
  List<JobTitle> jobTitles = [
    JobTitle('Software Engineer'),
    JobTitle('Product Manager'),
    JobTitle('Designer'),
  ];
  String selectedJobTitle = 'Software Engineer';
  String selectedLocation = 'India (PAN)';
  List<String> locationOptions = [
    'India (PAN)',
    'Delhi',
    'Mumbai',
    'Bangalore',
    'Chennai',
    'Hyderabad',
    'Kolkata',
    'Pune',
    'Other',
  ];
  String selectedStatus = 'All';
  List<String> statusOptions = [
    'All',
    'Existing',
    'Recent',
  ];
  String searchQuery = '';

  static const List<String> _appBarTitles = [
    'Dashboard',
    'Chat',
    'Observe',
    'Profile',
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addJobTitle() {
    showDialog(
      context: context,
      builder: (context) {
        String newTitle = '';
        return AlertDialog(
          title: Text('Add Job Title'),
          content: TextField(
            onChanged: (value) => newTitle = value,
            decoration: InputDecoration(hintText: 'Job Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newTitle.isNotEmpty) {
                  setState(() {
                    jobTitles.add(JobTitle(newTitle));
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          // Search TextField
          Expanded(
            flex: 3,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(width: 8),
          // Filter Button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              icon: Icon(Icons.filter_list),
              label: Text(_getFilterSummary()),
              onPressed: _showFilterDialog,
            ),
          ),
        ],
      ),
    );
  }

  String _getFilterSummary() {
    String loc = selectedLocation == 'India (PAN)' ? '' : selectedLocation;
    String stat = selectedStatus == 'All' ? '' : selectedStatus;
    if (loc.isEmpty && stat.isEmpty) return 'Filter';
    if (loc.isNotEmpty && stat.isNotEmpty) return '$loc, $stat';
    return loc.isNotEmpty ? loc : stat;
  }

  void _showFilterDialog() async {
    String tempLocation = selectedLocation;
    String tempStatus = selectedStatus;
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('By Location:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              DropdownButton<String>(
                isExpanded: true,
                value: tempLocation,
                items: locationOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  tempLocation = newValue!;
                  (context as Element).markNeedsBuild();
                },
              ),
              SizedBox(height: 16),
              Text('By Status:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              DropdownButton<String>(
                isExpanded: true,
                value: tempStatus,
                items: statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  tempStatus = newValue!;
                  (context as Element).markNeedsBuild();
                },
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedLocation = tempLocation;
                        selectedStatus = tempStatus;
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(),
          Container(
            height: 50,
            child: _buildJobTitlesRow(),
          ),
          Expanded(
            child: ApplicantList(
              applicants: mockApplicants,
              selectedJobTitle: selectedJobTitle,
              selectedLocation: selectedLocation,
              selectedStatus: selectedStatus,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTitlesRow() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: jobTitles.length + 1,
      itemBuilder: (context, index) {
        if (index == jobTitles.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: Size(40, 40)),
              onPressed: _addJobTitle,
              child: Icon(Icons.add),
            ),
          );
        }
        final job = jobTitles[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text(job.name),
            selected: selectedJobTitle == job.name,
            onSelected: (_) => setState(() => selectedJobTitle = job.name),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchRecruiterProfile();
  }

  Future<void> fetchRecruiterProfile() async {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null || userEmail.trim().isEmpty) {
      setState(() {
        profileErrorMsg = 'Error: Email is missing. Cannot fetch profile.';
        isProfileLoading = false;
      });
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('recruiters')
          .doc(userEmail.trim())
          .get();
      if (doc.exists) {
        setState(() {
          recruiterProfileData = doc.data();
          isProfileLoading = false;
        });
      } else {
        setState(() {
          profileErrorMsg = 'Profile not found.';
          isProfileLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        profileErrorMsg = 'Error fetching profile: $e';
        isProfileLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    final List<Widget> pages = <Widget>[
      const SizedBox.shrink(),
      ChatPage(),
      ObservePage(),
      ProfilePage(
        email: userEmail ?? '',
        userData: recruiterProfileData,
      ),
    ];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: _appBarTitles[_selectedIndex],
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onVipPressed: () {},
      ),
      drawer: CustomDrawer(authProvider: authProvider),
      body: DefaultTextStyle(
        style: GoogleFonts.playfairDisplay(color: Colors.black),
        child: _selectedIndex == 0 ? _buildHomeContent() : pages[_selectedIndex],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
