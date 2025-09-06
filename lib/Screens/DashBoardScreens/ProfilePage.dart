// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ProfilePage extends StatefulWidget {
//   final String email;
//   final Map<String, dynamic>? userData;
//
//   const ProfilePage({Key? key, required this.email, this.userData})
//       : super(key: key);
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
//         errorMsg = 'Error: Email is missing.';
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
//   Widget _buildProfileSection({
//     required String title,
//     required String value,
//     required IconData icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.indigo.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               icon,
//               color: Colors.indigo,
//               size: 24,
//             ),
//           ),
//           SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontFamily: 'Inter',
//                   fontSize: 16,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const Color primaryColor = Color(0xFF4A69BD);
//     const Color backgroundColor = Color(0xFFF0F4F8);
//     const Color textColor = Color(0xFF333333);
//
//     if (isLoading) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     if (errorMsg != null) {
//       return Center(
//         child: Text(
//           errorMsg!,
//           style: TextStyle(
//             fontFamily: 'Inter',
//             color: Colors.red,
//             fontSize: 16,
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(vertical: 32),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 120,
//                       height: 120,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.indigo.withOpacity(0.1),
//                       ),
//                       child: Center(
//                         child: Text(
//                           (userData?['recruiterName'] ?? 'U')[0].toUpperCase(),
//                           style: TextStyle(
//                             fontFamily: 'Inter',
//                             fontSize: 48,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.indigo,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       userData?['recruiterName'] ?? 'Unknown',
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       widget.email,
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Personal Information',
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     _buildProfileSection(
//                       title: 'Phone Number',
//                       value: userData?['contact'] ?? 'Not provided',
//                       icon: Icons.phone_outlined,
//                     ),
//                     _buildProfileSection(
//                       title: 'Company Name',
//                       value: userData?['companyName'] ?? 'Not provided',
//                       icon: Icons.business_outlined,
//                     ),
//                     _buildProfileSection(
//                       title: 'Location',
//                       value: userData?['location'] ?? 'Not provided',
//                       icon: Icons.location_on_outlined,
//                     ),
//                     _buildProfileSection(
//                       title: 'Position',
//                       value: userData?['position'] ?? 'Not provided',
//                       icon: Icons.work_outline_rounded,
//                     ),
//                     SizedBox(height: 24),
//                     Text(
//                       'Account Information',
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     _buildProfileSection(
//                       title: 'Account Type',
//                       value: userData?['accountType'] ?? 'Standard',
//                       icon: Icons.account_circle_outlined,
//                     ),
//                     _buildProfileSection(
//                       title: 'Member Since',
//                       value: 'January 2024', // You can format this from actual data
//                       icon: Icons.calendar_today_outlined,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Add edit profile functionality
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.indigo,
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     minimumSize: Size(double.infinity, 50),
//                   ),
//                   child: Text(
//                     'Edit Profile',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Widget _buildProfileSection({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.indigo,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Social Media Links Section
  Widget _buildSocialSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link, color: Colors.indigo, size: 24),
              SizedBox(width: 8),
              Text(
                'Social Links',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildSocialLink(
              'LinkedIn',
              userData?['linkedinUrl'] ?? userData?['linkedin'],
              Icons.business_center,
              Color(0xFF0077B5)
          ),
          _buildSocialLink(
              'Twitter',
              userData?['twitterUrl'] ?? userData?['twitter'],
              Icons.alternate_email,
              Color(0xFF1DA1F2)
          ),
          _buildSocialLink(
              'Facebook',
              userData?['facebookUrl'] ?? userData?['facebook'],
              Icons.facebook,
              Color(0xFF1877F2)
          ),
          _buildSocialLink(
              'Instagram',
              userData?['instagramUrl'] ?? userData?['instagram'],
              Icons.camera_alt,
              Color(0xFFE4405F)
          ),
          SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: _editSocialLinks,
              icon: Icon(Icons.edit, size: 18),
              label: Text('Edit Social Links'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.indigo,
                backgroundColor: Colors.indigo.withOpacity(0.1),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Divider
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLink(String platform, String? url, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  url != null && url.isNotEmpty ? url : 'Not added',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: url != null && url.isNotEmpty ? color : Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (url != null && url.isNotEmpty)
            IconButton(
              onPressed: () => _openUrl(url),
              icon: Icon(Icons.open_in_new, size: 18, color: Colors.grey[600]),
              tooltip: 'Open $platform',
            ),
        ],
      ),
    );
  }

  // Website Section
  Widget _buildWebsiteSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.web, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text(
                'Website & Portfolio',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildWebsiteLink(
              'Company Website',
              userData?['companyWebsite'] ?? userData?['website'],
              Icons.business,
              Colors.blue
          ),
          _buildWebsiteLink(
              'Portfolio',
              userData?['portfolioUrl'] ?? userData?['portfolio'],
              Icons.work,
              Colors.purple
          ),
          _buildWebsiteLink(
              'Blog/Personal Website',
              userData?['personalWebsite'] ?? userData?['blog'],
              Icons.article,
              Colors.orange
          ),
          SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: _editWebsiteLinks,
              icon: Icon(Icons.edit, size: 18),
              label: Text('Edit Website Links'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                backgroundColor: Colors.green.withOpacity(0.1),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebsiteLink(String title, String? url, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  url != null && url.isNotEmpty ? url : 'Not added',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: url != null && url.isNotEmpty ? color : Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (url != null && url.isNotEmpty)
            IconButton(
              onPressed: () => _openUrl(url),
              icon: Icon(Icons.open_in_new, size: 18, color: Colors.grey[600]),
              tooltip: 'Visit Website',
            ),
        ],
      ),
    );
  }

  // Helper Methods
  Future<void> _openUrl(String url) async {
    // Ensure URL has protocol
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editSocialLinks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Social Links'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditLinkField('LinkedIn URL', userData?['linkedinUrl']),
              SizedBox(height: 12),
              _buildEditLinkField('Twitter URL', userData?['twitterUrl']),
              SizedBox(height: 12),
              _buildEditLinkField('Facebook URL', userData?['facebookUrl']),
              SizedBox(height: 12),
              _buildEditLinkField('Instagram URL', userData?['instagramUrl']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _saveSocialLinks,
            child: Text('Save'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
          ),
        ],
      ),
    );
  }

  void _editWebsiteLinks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Website Links'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditLinkField('Company Website', userData?['companyWebsite']),
              SizedBox(height: 12),
              _buildEditLinkField('Portfolio URL', userData?['portfolioUrl']),
              SizedBox(height: 12),
              _buildEditLinkField('Personal Website', userData?['personalWebsite']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _saveWebsiteLinks,
            child: Text('Save'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildEditLinkField(String label, String? currentValue) {
    return TextFormField(
      initialValue: currentValue ?? '',
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.link, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      keyboardType: TextInputType.url,
    );
  }

  void _saveSocialLinks() {
    // Implement save logic to Firebase
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Social links updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _saveWebsiteLinks() {
    // Implement save logic to Firebase
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Website links updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMsg != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                errorMsg!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.red,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: fetchUserData,
                child: Text('Retry'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Text(
                          (userData?['recruiterName'] ?? 'U')[0].toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      userData?['recruiterName'] ?? 'Unknown',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.email,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Personal Information
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildProfileSection(
                      title: 'Phone Number',
                      value: userData?['contact'] ?? 'Not provided',
                      icon: Icons.phone_outlined,
                    ),
                    _buildProfileSection(
                      title: 'Company Name',
                      value: userData?['companyName'] ?? 'Not provided',
                      icon: Icons.business_outlined,
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.grey[200],
              ),

              // Account Information
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Information',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildProfileSection(
                      title: 'Account Type',
                      value: userData?['accountType'] ?? 'Standard',
                      icon: Icons.account_circle_outlined,
                    ),
                    _buildProfileSection(
                      title: 'Member Since',
                      value: 'January 2024',
                      icon: Icons.calendar_today_outlined,
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.grey[200],
              ),

              // Social Media Links Section
              _buildSocialSection(),

              // Website Section
              _buildWebsiteSection(),

              SizedBox(height: 20),

              // Edit Profile Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    // Add edit profile functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
