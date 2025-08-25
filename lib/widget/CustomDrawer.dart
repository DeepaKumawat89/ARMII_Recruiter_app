import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../LoginPage.dart';
import '../auth_provider.dart' as my_auth;
import 'drawer/ManageBot.dart';
import 'drawer/ManageGreetings.dart';
import 'drawer/MoreSetting.dart';
import 'drawer/PaymentTracking.dart';
import 'drawer/RequestHelp.dart';
import 'drawer/Reportissue.dart';
import 'drawer/SwitchAccount.dart';
import 'drawer/UpdateSoftware.dart';


class CustomDrawer extends StatelessWidget {
  final my_auth.AuthProvider authProvider;
  const CustomDrawer({Key? key, required this.authProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.indigo;
    final Color accentColor = Colors.white;
    final Color dividerColor = Colors.grey.shade300;
    final Color textColor = Colors.indigo.shade900;
    final Color iconBgColor = Colors.indigo.shade100;
    final Color menuTextColor = Colors.indigo.shade700;
    final Color menuHighlightColor = Colors.indigo.shade50;

    return Drawer(
      child: Container(
        color: accentColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Simple Profile Section with rounded border and row layout
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 12.0, right: 12.0, bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 18),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: iconBgColor,
                      child: Icon(Icons.person, size: 50, color: primaryColor),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                        Text(
                          'View & Edit',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 12,
                            color: accentColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.chat_bubble_outline, color: primaryColor, size: 22),
                            SizedBox(height: 2),
                            Text('Chats', style: GoogleFonts.playfairDisplay(fontSize: 13, color: textColor)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.bookmark_border, color: primaryColor, size: 22),
                            SizedBox(height: 2),
                            Text('Saved', style: GoogleFonts.playfairDisplay(fontSize: 13, color: textColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.check_circle_outline, color: primaryColor, size: 22),
                            SizedBox(height: 2),
                            Text('Hired', style: GoogleFonts.playfairDisplay(fontSize: 13, color: textColor)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.cancel_outlined, color: primaryColor, size: 22),
                            SizedBox(height: 2),
                            Text('Rejected', style: GoogleFonts.playfairDisplay(fontSize: 13, color: textColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: dividerColor),
            // Two Buttons in a Row - simple layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        backgroundColor: accentColor,
                        foregroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text('Existing Job Posts', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        backgroundColor: accentColor,
                        foregroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text('Posts New Job', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            // Column of menu texts below buttons as ListTiles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0,),
              child: Column(
                children: [
                  _drawerTile(Icons.message, 'Manage Greetings', menuTextColor, context, const ManageGreetings()),
                  _drawerTile(Icons.smart_toy, 'Manage Bot', menuTextColor, context, const ManageBot()),
                  _drawerTile(Icons.payment, 'Payment & Tracking', menuTextColor, context,  PaymentTracking()),
                  _drawerTile(Icons.switch_account, 'Switch Account', menuTextColor, context,  SwitchAccount()),
                  _drawerTile(Icons.help_outline, 'Request Help', menuTextColor, context, const RequestHelp()),
                  _drawerTile(Icons.report_problem_outlined, 'Request Issue', menuTextColor, context, const ReportIssue()),
                  _drawerTile(Icons.settings, 'More Setting', menuTextColor, context, const MoreSetting()),
                  _drawerTile(Icons.system_update, 'Update software', menuTextColor, context, const UpdateSoftware()),
                ],
              ),
            ),
            Divider(thickness: 1, color: dividerColor),
            // Logout Button
            ListTile(
              leading: Icon(Icons.logout, color: primaryColor),
              title: Text('Logout', style: GoogleFonts.playfairDisplay(color: primaryColor)),
              onTap: () async {
                await authProvider.logout();
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, Color textColor, BuildContext context, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: ListTile(
        leading: Icon(icon, color: textColor),
        title: Text(title, style: GoogleFonts.playfairDisplay(color: textColor)),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => page),
          );
        },
        hoverColor: Colors.indigo.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        dense: true,
        visualDensity: VisualDensity(vertical: -2),
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      ),
    );
  }
}
