import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreSetting extends StatelessWidget {
  const MoreSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hardcoded values for UI only
    final ThemeMode themeMode = ThemeMode.light;
    final bool appLockEnabled = false;
    final bool biometricEnabled = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('More Setting', style: GoogleFonts.playfairDisplay()),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.color_lens, color: Colors.indigo),
            title: Text('Theme', style: GoogleFonts.playfairDisplay()),
            subtitle: Text(themeMode == ThemeMode.light
                ? 'Light'
                : themeMode == ThemeMode.dark
                    ? 'Dark'
                    : 'System'),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              items: const [
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
              ],
              onChanged: null, // Disabled for UI only
            ),
          ),
          SwitchListTile(
            secondary: Icon(Icons.lock, color: Colors.indigo),
            title: Text('App Lock', style: GoogleFonts.playfairDisplay()),
            value: appLockEnabled,
            onChanged: null, // Disabled for UI only
          ),
          if (appLockEnabled)
            SwitchListTile(
              secondary: Icon(Icons.fingerprint, color: Colors.indigo),
              title: Text('Unlock with Fingerprint', style: GoogleFonts.playfairDisplay()),
              value: biometricEnabled,
              onChanged: null, // Disabled for UI only
            ),
        ],
      ),
    );
  }
}
