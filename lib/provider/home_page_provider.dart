import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobTitle {
  final String name;
  JobTitle(this.name);
}

class HomePageProvider extends ChangeNotifier {
  int selectedIndex = 0;
  Map<String, dynamic>? recruiterProfileData;
  bool isProfileLoading = true;
  String? profileErrorMsg;

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

  static const List<String> appBarTitles = [
    'Dashboard',
    'Chat',
    'Observe',
    'Profile',
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void addJobTitle(String newTitle) {
    if (newTitle.isNotEmpty) {
      jobTitles.add(JobTitle(newTitle));
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void setFilter(String location, String status) {
    selectedLocation = location;
    selectedStatus = status;
    notifyListeners();
  }

  void setSelectedJobTitle(String jobTitle) {
    selectedJobTitle = jobTitle;
    notifyListeners();
  }

  String getFilterSummary() {
    String loc = selectedLocation == 'India (PAN)' ? '' : selectedLocation;
    String stat = selectedStatus == 'All' ? '' : selectedStatus;
    if (loc.isEmpty && stat.isEmpty) return 'Filter';
    if (loc.isNotEmpty && stat.isNotEmpty) return '$loc, $stat';
    return loc.isNotEmpty ? loc : stat;
  }

  Future<void> fetchRecruiterProfile() async {
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null || userEmail.trim().isEmpty) {
      profileErrorMsg = 'Error: Email is missing. Cannot fetch profile.';
      isProfileLoading = false;
      notifyListeners();
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('recruiters')
          .doc(userEmail.trim())
          .get();
      if (doc.exists) {
        recruiterProfileData = doc.data();
        isProfileLoading = false;
      } else {
        profileErrorMsg = 'Profile not found.';
        isProfileLoading = false;
      }
    } catch (e) {
      profileErrorMsg = 'Error fetching profile: $e';
      isProfileLoading = false;
    }
    notifyListeners();
  }
}
