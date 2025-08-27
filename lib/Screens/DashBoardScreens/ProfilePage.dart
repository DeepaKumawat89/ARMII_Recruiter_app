// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ProfilePage extends StatefulWidget {
//   final String email; // Email used as Firestore doc ID
//   final Map<String, dynamic>? userData;
//   const ProfilePage({Key? key, required this.email, this.userData}) : super(key: key);
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   Map<String, dynamic>? userData;
//   bool isLoading = true;
//   String? errorMsg;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.userData != null) {
//       userData = widget.userData;
//       isLoading = false;
//     } else {
//       fetchUserData();
//     }
//   }
//
//   Future<void> fetchUserData() async {
//     if (widget.email.trim().isEmpty) {
//       setState(() {
//         errorMsg = 'Error: Email is missing. Cannot fetch profile.';
//         isLoading = false;
//       });
//       return;
//     }
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('recruiters')
//           .doc(widget.email.trim())
//           .get();
//       if (doc.exists) {
//         setState(() {
//           userData = doc.data();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMsg = 'Profile not found.';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMsg = 'Error fetching profile: $e';
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F7FB),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Profile Header with name and company
//                 Center(
//                   child: Column(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.indigo.withAlpha((0.18 * 255).toInt()),
//                               blurRadius: 18,
//                               offset: Offset(0, 8),
//                             ),
//                           ],
//                           border: Border.all(color: Colors.indigo, width: 3),
//                         ),
//                         child: CircleAvatar(
//                           radius: 48,
//                           backgroundColor: Colors.indigo.shade100,
//                           child: Icon(Icons.account_circle, size: 80, color: Colors.indigo.shade400),
//                         ),
//                       ),
//                       const SizedBox(height: 18),
//                       Text(
//                         userData!['recruiterName'] ?? '',
//                         style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo[900]),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         userData!['companyName'] ?? '',
//                         style: GoogleFonts.playfairDisplay(fontSize: 16, color: Colors.indigo[400]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 // Details Section in Container
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
//                   child: Column(
//                     children: [
//                       _profileDetailRow(Icons.email, 'Email', userData!['email']),
//                       Divider(height: 28, thickness: 1, color: Color(0xFFE0E0E0)),
//                       _profileDetailRow(Icons.phone, 'Contact', userData!['contact']),
//                       Divider(height: 28, thickness: 1, color: Color(0xFFE0E0E0)),
//                       _profileDetailRow(Icons.public, 'Social Media', userData!['social']),
//                       Divider(height: 28, thickness: 1, color: Color(0xFFE0E0E0)),
//                       _profileDetailRow(Icons.language, 'Website', userData!['website']),
//                       Divider(height: 28, thickness: 1, color: Color(0xFFE0E0E0)),
//                       _profileDetailRow(Icons.calendar_today, 'Created At',
//                         userData!['createdAt'] != null ? userData!['createdAt'].toDate().toString() : ''),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _profileDetailRow(IconData icon, String title, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.indigo.withOpacity(0.08),
//               shape: BoxShape.circle,
//             ),
//             padding: const EdgeInsets.all(8),
//             child: Icon(icon, color: Colors.indigo, size: 28),
//           ),
//           const SizedBox(width: 18),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 17)),
//                 const SizedBox(height: 2),
//                 Text(value ?? '-', style: GoogleFonts.playfairDisplay(fontSize: 16, color: Colors.black87)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final String email;
  final Map<String, dynamic>? userData;

  const ProfilePage({Key? key, required this.email, this.userData})
      : super(key: key);

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
        errorMsg = 'Error: Email is missing.';
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
    const Color primaryColor = Color(0xFF4A69BD);
    const Color backgroundColor = Color(0xFFF0F4F8);
    const Color textColor = Color(0xFF333333);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: primaryColor),
              const SizedBox(height: 16),
              Text(
                'Loading profile...',
                style: GoogleFonts.poppins(color: textColor),
              ),
            ],
          ),
        )
            : errorMsg != null
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              errorMsg!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontSize: 16,
              ),
            ),
          ),
        )
            : userData == null
            ? Center(
          child: Text(
            'No profile data available.',
            style: GoogleFonts.poppins(color: textColor),
          ),
        )
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(
                    userData!['recruiterName'] ?? '',
                    userData!['companyName'] ?? ''),
                const SizedBox(height: 32),
                _buildDetailsContainer(userData!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String company) {
    const Color primaryColor = Color(0xFF4A69BD);
    const Color accentColor = Color(0xFF6B8FD9);

    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: accentColor.withOpacity(0.1),
              child: Icon(
                Icons.account_circle,
                size: 80,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            company,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: primaryColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsContainer(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _profileDetailRow(Icons.email, 'Email', data['email']),
          const Divider(height: 30, color: Color(0xFFEFEFEF)),
          _profileDetailRow(Icons.phone, 'Contact', data['contact']),
          const Divider(height: 30, color: Color(0xFFEFEFEF)),
          _profileDetailRow(Icons.public, 'Social Media', data['social']),
          const Divider(height: 30, color: Color(0xFFEFEFEF)),
          _profileDetailRow(Icons.language, 'Website', data['website']),
          const Divider(height: 30, color: Color(0xFFEFEFEF)),
          _profileDetailRow(
            Icons.calendar_today,
            'Created At',
            data['createdAt'] != null
                ? (data['createdAt'] as Timestamp).toDate().toString()
                : '',
          ),
        ],
      ),
    );
  }

  Widget _profileDetailRow(IconData icon, String title, String? value) {
    const Color primaryColor = Color(0xFF4A69BD);
    const Color textColor = Color(0xFF333333);
    const Color iconBackgroundColor = Color(0xFFE6EAF2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value?.isEmpty ?? true ? 'N/A' : value!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}