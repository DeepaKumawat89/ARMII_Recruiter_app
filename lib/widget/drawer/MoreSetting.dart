import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:armii_recruiter_app/main.dart';
import 'package:local_auth/local_auth.dart';

class MoreSetting extends StatefulWidget {
  const MoreSetting({Key? key}) : super(key: key);

  @override
  State<MoreSetting> createState() => _MoreSettingState();
}

class _MoreSettingState extends State<MoreSetting> {
  ThemeMode? _themeMode;
  bool _appLockEnabled = false;
  bool _biometricEnabled = false;
  final _storage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = themeNotifier.value;
      _appLockEnabled = (prefs.getBool('appLock') ?? false);
      _biometricEnabled = (prefs.getBool('biometricLock') ?? false);
    });
  }

  Future<void> _setTheme(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    themeNotifier.value = mode;
    await saveTheme(mode);
  }

  Future<void> _toggleAppLock(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value) {
      // Set PIN
      final pin = await _showPinDialog(setPin: true);
      if (pin != null && pin.length == 4) {
        await _storage.write(key: 'appPin', value: pin);
        await prefs.setBool('appLock', true);
        setState(() => _appLockEnabled = true);
      }
    } else {
      await _storage.delete(key: 'appPin');
      await prefs.setBool('appLock', false);
      setState(() => _appLockEnabled = false);
      // Also disable biometric if app lock is off
      await prefs.setBool('biometricLock', false);
      setState(() => _biometricEnabled = false);
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value) {
      final canCheck = await _localAuth.canCheckBiometrics;
      final available = await _localAuth.getAvailableBiometrics();
      if (canCheck && available.isNotEmpty) {
        setState(() => _biometricEnabled = true);
        await prefs.setBool('biometricLock', true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No biometric hardware found or not enrolled.')),
        );
      }
    } else {
      setState(() => _biometricEnabled = false);
      await prefs.setBool('biometricLock', false);
    }
  }

  Future<String?> _showPinDialog({required bool setPin}) async {
    String pin = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(setPin ? 'Set 4-digit PIN' : 'Enter PIN'),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => pin = value,
            decoration: InputDecoration(hintText: 'PIN'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (pin.length == 4) {
                  Navigator.pop(context, pin);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            subtitle: Text(_themeMode == ThemeMode.light
                ? 'Light'
                : _themeMode == ThemeMode.dark
                    ? 'Dark'
                    : 'System'),
            trailing: DropdownButton<ThemeMode>(
              value: _themeMode,
              items: const [
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
              ],
              onChanged: (mode) {
                if (mode != null) _setTheme(mode);
              },
            ),
          ),
          SwitchListTile(
            secondary: Icon(Icons.lock, color: Colors.indigo),
            title: Text('App Lock', style: GoogleFonts.playfairDisplay()),
            value: _appLockEnabled,
            onChanged: (val) => _toggleAppLock(val),
          ),
          if (_appLockEnabled)
            SwitchListTile(
              secondary: Icon(Icons.fingerprint, color: Colors.indigo),
              title: Text('Unlock with Fingerprint', style: GoogleFonts.playfairDisplay()),
              value: _biometricEnabled,
              onChanged: (val) => _toggleBiometric(val),
            ),
        ],
      ),
    );
  }
}
