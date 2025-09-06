import 'package:armii_recruiter_app/Screens/SplashScreen.dart';
import 'package:armii_recruiter_app/company_profile/CompanyProfilePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_state.dart';
import 'firebase_options.dart';
import 'provider/internship_provider.dart';
import 'provider/job_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const pdfAssetPath = 'assets/pdf/Deepak_Kumawat_Resume.pdf';
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => InternshipProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        // home: WhatsappStylePdfPreview(pdfAssetPath: pdfAssetPath),
      ),
    ),
  );
}
