import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final String email; // Email used as Firestore doc ID
  final Map<String, dynamic>? userData;
  const ProfilePage({Key? key, required this.email, this.userData}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      userData = widget.userData;
      isLoading = false;
    } else {
      fetchUserData();
    }
  }

  Future<void> fetchUserData() async {
    if (widget.email.trim().isEmpty) {
      setState(() {
        errorMsg = 'Error: Email is missing. Cannot fetch profile.';
        isLoading = false;
      });
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('recruiters')
          .doc(widget.email.trim())
          .get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = 'Profile not found.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Error fetching profile: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
            : errorMsg != null
                ? Center(child: Text(errorMsg!, style: const TextStyle(color: Colors.red, fontSize: 18)))
                : userData == null
                    ? const Center(child: Text('No data found.', style: TextStyle(color: Colors.black)))
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        children: [
                          // Profile Header
                          Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            margin: const EdgeInsets.only(bottom: 24),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.indigo.shade100,
                                    child: Icon(Icons.account_circle, size: 70, color: Colors.indigo.shade400),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    userData!['recruiterName'] ?? '',
                                    style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    userData!['companyName'] ?? '',
                                    style: GoogleFonts.playfairDisplay(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Details Section
                          Text('Account Details',
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 12),
                          _profileDetailCard(Icons.business_center, 'Recruiting For', userData!['recruitingFor']),
                          _profileDetailCard(Icons.email, 'Email', userData!['email']),
                          _profileDetailCard(Icons.phone, 'Contact', userData!['contact']),
                          _profileDetailCard(Icons.public, 'Social Media', userData!['social']),
                          _profileDetailCard(Icons.language, 'Website', userData!['website']),
                          _profileDetailCard(Icons.calendar_today, 'Created At',
                            userData!['createdAt'] != null ? userData!['createdAt'].toDate().toString() : ''),
                        ],
                      ),
      ),
    );
  }

  Widget _profileDetailCard(IconData icon, String title, String? value) {
    return Card(
      color: Colors.white.withOpacity(0.95),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo, size: 28),
        title: Text(title, style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        subtitle: Text(value ?? '-', style: GoogleFonts.playfairDisplay(fontSize: 16)),
      ),
    );
  }
}
