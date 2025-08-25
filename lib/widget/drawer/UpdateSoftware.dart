import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateSoftware extends StatefulWidget {
  const UpdateSoftware({Key? key}) : super(key: key);

  @override
  State<UpdateSoftware> createState() => _UpdateSoftwareState();
}

class _UpdateSoftwareState extends State<UpdateSoftware> {
  // Dummy data for versions
  String currentVersion = '1.0.0';
  String latestVersion = '1.1.0';
  String releaseNotes =
      '- Improved performance\n- Bug fixes\n- New feature: Dark mode';
  bool isChecking = false;
  bool updateAvailable = true;

  void checkForUpdates() async {
    setState(() {
      isChecking = true;
    });
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isChecking = false;
      // For demo, always show update available
      updateAvailable = true;
      latestVersion = '1.1.0';
      releaseNotes =
          '- Improved performance\n- Bug fixes\n- New feature: Dark mode';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Checked for updates!')),
    );
  }

  void updateApp() {
    // Dummy update action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Redirecting to app store...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Software', style: GoogleFonts.playfairDisplay()),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Version',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            SizedBox(height: 4),
            Text(currentVersion,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  color: Colors.indigo.shade900,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 24),
            Text('Latest Version',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                )),
            SizedBox(height: 4),
            Text(latestVersion,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  color: Colors.indigo.shade900,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 12),
            Text('Release Notes',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                )),
            SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(releaseNotes,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 15,
                  )),
            ),
            SizedBox(height: 32),
            if (isChecking)
              Center(child: CircularProgressIndicator(color: Colors.indigo)),
            if (!isChecking)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(Icons.refresh),
                      label: Text('Check for Updates',
                          style: GoogleFonts.playfairDisplay(fontSize: 16)),
                      onPressed: checkForUpdates,
                    ),
                  ),
                  if (updateAvailable) ...[
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(Icons.system_update_alt),
                        label: Text('Update Now',
                            style: GoogleFonts.playfairDisplay(fontSize: 16)),
                        onPressed: updateApp,
                      ),
                    ),
                  ]
                ],
              ),
          ],
        ),
      ),
    );
  }
}
