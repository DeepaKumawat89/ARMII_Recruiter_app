import 'package:flutter/material.dart';

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
        title: Text('More Setting', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.color_lens, color: Colors.indigo),
            title: Text('Theme', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
            subtitle: Text(
              themeMode == ThemeMode.light
                  ? 'Light'
                  : themeMode == ThemeMode.dark
                      ? 'Dark'
                      : 'System',
              style: TextStyle(fontFamily: 'Inter'),
            ),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              items: const [
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light', style: TextStyle(fontFamily: 'Inter'))),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark', style: TextStyle(fontFamily: 'Inter'))),
                DropdownMenuItem(value: ThemeMode.system, child: Text('System', style: TextStyle(fontFamily: 'Inter'))),
              ],
              onChanged: null, // Disabled for UI only
            ),
          ),
          SwitchListTile(
            secondary: Icon(Icons.lock, color: Colors.indigo),
            title: Text('App Lock', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
            value: appLockEnabled,
            onChanged: null, // Disabled for UI only
          ),
          if (appLockEnabled)
            SwitchListTile(
              secondary: Icon(Icons.fingerprint, color: Colors.indigo),
              title: Text('Unlock with Fingerprint', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
              value: biometricEnabled,
              onChanged: null, // Disabled for UI only
            ),
        ],
      ),
    );
  }
}
