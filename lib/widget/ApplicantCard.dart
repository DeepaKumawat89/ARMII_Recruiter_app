import 'package:flutter/material.dart';

import '../Screens/DashBoardScreens/SubScreen/ApplicantDetailsPage.dart';

class Applicant {
  final String name;
  final String jobTitle;
  final String status;
  final String location;
  Applicant({required this.name, required this.jobTitle, required this.status, required this.location});
}

class ApplicantCard extends StatelessWidget {
  final Applicant applicant;
  const ApplicantCard({Key? key, required this.applicant}) : super(key: key);

  Color _statusColor(String status) {
    switch (status) {
      case 'Interviewed':
        return Colors.green.shade100;
      case 'Pending':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'Interviewed':
        return Colors.green.shade800;
      case 'Pending':
        return Colors.orange.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApplicantDetailsPage(applicant: applicant),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                child: Text(
                  applicant.name.isNotEmpty ? applicant.name[0] : '?',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 22)
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant.name,
                      style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 18)
                    ),
                    SizedBox(height: 4),
                    Text(
                      applicant.jobTitle,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 15, color: Colors.grey[700])
                    ),
                    SizedBox(height: 2),
                    Text(
                      applicant.location,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.grey[500])
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(applicant.status),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  applicant.status.isEmpty ? 'N/A' : applicant.status,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: _statusTextColor(applicant.status),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
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

class ApplicantList extends StatelessWidget {
  final List<Applicant> applicants;
  final String selectedJobTitle;
  final String selectedLocation;
  final String selectedStatus;

  const ApplicantList({
    Key? key,
    required this.applicants,
    required this.selectedJobTitle,
    required this.selectedLocation,
    required this.selectedStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filtered = applicants.where((a) {
      final matchesJob = a.jobTitle == selectedJobTitle;
      final matchesLocation = selectedLocation == 'India (PAN)' || a.location == selectedLocation;
      bool matchesStatus;
      if (selectedStatus == 'All') {
        matchesStatus = true;
      } else if (selectedStatus == 'Existing') {
        matchesStatus = a.status == 'Interviewed';
      } else if (selectedStatus == 'Recent') {
        matchesStatus = a.status == 'Pending';
      } else {
        matchesStatus = false;
      }
      return matchesJob && matchesLocation && matchesStatus;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 48, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'No applicants found',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Try adjusting your filters',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Text(
            'Applicants',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return ApplicantCard(applicant: filtered[index]);
            },
          ),
        ),
      ],
    );
  }
}

final List<Applicant> mockApplicants = [
  Applicant(name: 'Alice', jobTitle: 'Software Engineer', status: '', location: 'Delhi'),
  Applicant(name: 'Bob', jobTitle: 'Product Manager', status: 'Interviewed', location: 'Mumbai'),
  Applicant(name: 'Charlie', jobTitle: 'Designer', status: 'Pending', location: 'Bangalore'),
  Applicant(name: 'Diana', jobTitle: 'Software Engineer', status: 'Interviewed', location: 'Chennai'),
  Applicant(name: 'Eve', jobTitle: 'Product Manager', status: 'Pending', location: 'Hyderabad'),
  Applicant(name: 'Frank', jobTitle: 'Designer', status: 'Interviewed', location: 'Kolkata'),
  Applicant(name: 'Grace', jobTitle: 'Software Engineer', status: 'Pending', location: 'Pune'),
  Applicant(name: 'Heidi', jobTitle: 'Product Manager', status: 'Interviewed', location: 'Other'),
  Applicant(name: 'Ivan', jobTitle: 'Designer', status: 'Pending', location: 'Delhi'),
  Applicant(name: 'Judy', jobTitle: 'Software Engineer', status: 'Interviewed', location: 'Mumbai'),
];
