import 'package:armii_recruiter_app/SplashScreen.dart';
import 'package:armii_recruiter_app/company_profile/CompanyProfilePage.dart';
import 'package:armii_recruiter_app/whatsappppreview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final themeIndex = prefs.getInt('themeMode') ?? 2;
  themeNotifier.value = ThemeMode.values[themeIndex];
}

Future<void> saveTheme(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('themeMode', mode.index);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await loadTheme();

  const pdfAssetPath = 'assets/pdf/Deepak_Kumawat_Resume.pdf';
  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: mode,
        home: SplashScreen(),
        // home: WhatsappStylePdfPreview(pdfAssetPath: pdfAssetPath),
      ),
    ),
  );
}
