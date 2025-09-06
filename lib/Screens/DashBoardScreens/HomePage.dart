import 'package:flutter/material.dart';
import '../plusicononclick.dart';
import 'ObservePage.dart';
import 'ProfilePage.dart';
import '../../Auth/auth_provider.dart' as my_auth;
import 'ChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widget/CustomAppBar.dart';
import '../../widget/CustomBottomNavBar.dart';
import '../../widget/CustomDrawer.dart';
import '../../widget/ApplicantCard.dart';
import 'package:provider/provider.dart';
import '../../provider/home_page_provider.dart';
import '../drawer/JobCreationPage.dart';
import '../drawer/InternshipCreationPage.dart';
import 'SubScreen/VIPpage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = HomePageProvider();
        provider.fetchRecruiterProfile();
        return provider;
      },
      child: _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey plusIconKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // Set this value to control the right padding of the menu
    const double menuRightPadding = 150.0; // Change as needed

    final provider = Provider.of<HomePageProvider>(context);
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    final List<Widget> pages = <Widget>[
      SizedBox.shrink(),
      ChatPage(),
      ObservePage(),
      ProfilePage(
        email: userEmail ?? '',
        userData: provider.recruiterProfileData,
      ),
    ];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: HomePageProvider.appBarTitles[provider.selectedIndex],
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onVipPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const VipPage()),
          );
        },
        onPlusPressed: () => handlePlusIconClick(
          context: context,
          iconKey: plusIconKey,
          topPadding: 0,        // Customize top padding below appbar
          rightPadding: 0,       // Adjust right padding if needed
          leftPadding: 40, // Or adjust left padding if you want
          dialogWidth: 200,      // Customize dialog width
          dialogHeight: 85,      // Customize dialog height
        ),
        plusIconKey: plusIconKey,
      ),

      drawer: CustomDrawer(authProvider: my_auth.AuthProvider()),
      body: DefaultTextStyle(
        style: TextStyle(fontFamily: 'Inter', color: Colors.black),
        child: provider.selectedIndex == 0 ? _buildHomeContent(context, provider) : pages[provider.selectedIndex],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: provider.selectedIndex,
        onItemTapped: provider.onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, HomePageProvider provider) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(context, provider),
          Container(
            height: screenHeight * 0.06,
            child: _buildJobTitlesRow(context, provider),
          ),
          Expanded(
            child: ApplicantList(
              applicants: mockApplicants,
              selectedJobTitle: provider.selectedJobTitle,
              selectedLocation: provider.selectedLocation,
              selectedStatus: provider.selectedStatus,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context, HomePageProvider provider) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: screenHeight * 0.05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(fontFamily: 'Inter'),
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
                ),
                style: TextStyle(fontFamily: 'Inter'),
                onChanged: provider.setSearchQuery,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  // side: BorderSide(color: Colors.grey.shade300),
                ),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
              ),
              icon: Icon(Icons.filter_list),
              label: Text(provider.getFilterSummary(), style: TextStyle(fontFamily: 'Inter')),
              onPressed: () => _showFilterDialog(context, provider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTitlesRow(BuildContext context, HomePageProvider provider) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: provider.jobTitles.length + 1,
      itemBuilder: (context, index) {
        if (index == provider.jobTitles.length) {
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: Size(40, 40)),
              onPressed: () => _addJobTitle(context, provider),
              child: Icon(Icons.add),
            ),
          );
        }
        final job = provider.jobTitles[index];
        return Padding(
          padding:  EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text(job.name, style: TextStyle(fontFamily: 'Inter')),
            selected: provider.selectedJobTitle == job.name,
            onSelected: (_) => provider.setSelectedJobTitle(job.name),
          ),
        );
      },
    );
  }

  void _addJobTitle(BuildContext context, HomePageProvider provider) {

    showDialog(
      context: context,
      builder: (context) {
        String newTitle = '';
        return AlertDialog(
          title: Text('Add Job Title', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
          content: TextField(
            onChanged: (value) => newTitle = value,
            decoration: InputDecoration(
              hintText: 'Job Title',
              hintStyle: TextStyle(fontFamily: 'Inter'),
            ),
            style: TextStyle(fontFamily: 'Inter'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newTitle.isNotEmpty) {
                  provider.addJobTitle(newTitle);
                }
                Navigator.of(context).pop();
              },
              child: Text('Add', style: TextStyle(fontFamily: 'Inter')),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context, HomePageProvider provider) async {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String tempLocation = provider.selectedLocation;
    String tempStatus = provider.selectedStatus;
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.04,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              ),
              SizedBox(height: 16),
              Text('By Location:',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                )
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: tempLocation,
                items: provider.locationOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14
                      )
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  tempLocation = newValue!;
                  (context as Element).markNeedsBuild();
                },
              ),
              SizedBox(height: 16),
              Text('By Status:',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                )
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: tempStatus,
                items: provider.statusOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14
                      )
                    ),
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
                    child: Text('Cancel', style: TextStyle(fontFamily: 'Inter')),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      provider.setFilter(tempLocation, tempStatus);
                      Navigator.pop(context);
                    },
                    child: Text('Apply', style: TextStyle(fontFamily: 'Inter')),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
