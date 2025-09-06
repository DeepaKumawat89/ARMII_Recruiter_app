import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_provider.dart';
import '../Screens/DashBoardScreens/HomePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class CreateAccountPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController recruiterNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController socialController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final AuthProvider authProvider = AuthProvider();

  final ValueNotifier<String?> uploadedFileName = ValueNotifier<String?>(null);
  final ValueNotifier<String?> recruitingFor = ValueNotifier<String?>(null);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String> selectedCountryCode = ValueNotifier<String>('+91');
  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);

  CreateAccountPage({Key? key}) : super(key: key);

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@gmail\.com$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~_\-])[A-Za-z\d!@#\$&*~_\-]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> _pickFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg', 'doc', 'docx'],
    );
    if (result != null && result.files.isNotEmpty) {
      uploadedFileName.value = result.files.single.name;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ File Selected: "+result.files.single.name),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text("❌ No file selected"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final user = await authProvider.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        final data = {
          'recruitingFor': recruitingFor.value,
          'companyName': companyNameController.text.trim(),
          'recruiterName': recruiterNameController.text.trim(),
          'email': emailController.text.trim(),
          'contact': selectedCountryCode.value + contactController.text.trim(),
          'social': socialController.text.trim(),
          'website': websiteController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        };
        await FirebaseFirestore.instance.collection('recruiters').doc(emailController.text.trim()).set(data);
        Fluttertoast.showToast(
          msg: "Account successfully created!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Provider usage: increment AppState counter after account creation
        context.read<AppState>().increment();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, _) => AbsorbPointer(
        absorbing: loading,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.07),
            child: AppBar(
              backgroundColor: Colors.indigo,
              centerTitle: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              title: Text(
                "Details & Verification",
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 4,
              leading: IconButton(
                icon:  Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // go back
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding:  EdgeInsets.all(screenWidth * 0.04),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Upload Certificate (PDF/Image/Doc)",
                      style: TextStyle(fontFamily: 'Inter', fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                   SizedBox(height: screenHeight * 0.01),
                  ValueListenableBuilder<String?>(
                    valueListenable: uploadedFileName,
                    builder: (context, fileName, _) => GestureDetector(
                      onTap: fileName == null ? () => _pickFile(context) : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                fileName == null
                                    ? "Click to Upload File"
                                    : "📂 $fileName",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Colors.black87,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            fileName == null
                                ? Icon(Icons.upload_file, color: Colors.deepPurple)
                                : GestureDetector(
                              onTap: () {
                                uploadedFileName.value = null;
                              },
                              child: Icon(Icons.cancel, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                   SizedBox(height: screenHeight * 0.025),
                  ValueListenableBuilder<String?>(
                    valueListenable: recruitingFor,
                    builder: (context, value, _) => DropdownButtonFormField<String>(
                      value: value,
                      items: ["Own Company", "For Other Company"]
                          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontFamily: 'Inter'))))
                          .toList(),
                      onChanged: (val) => recruitingFor.value = val,
                      validator: (val) => val == null ? 'Please select an option' : null,
                      decoration: InputDecoration(
                        labelText: "Recruiting For",
                        labelStyle: TextStyle(fontFamily: 'Inter', fontSize: screenWidth * 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                   SizedBox(height: screenHeight * 0.025),
                  TextFormField(
                    controller: companyNameController,
                    validator: (v) => v == null || v.isEmpty ? 'Enter company name' : null,
                    decoration: InputDecoration(
                      labelText: "Company Name",
                      labelStyle: TextStyle(fontFamily: 'Inter', fontSize: screenWidth * 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.business),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  TextFormField(
                    controller: recruiterNameController,
                    validator: (v) => v == null || v.isEmpty ? 'Enter recruiter name' : null,
                    decoration: InputDecoration(
                      labelText: "Owner / Recruiter Name",
                      labelStyle: TextStyle(fontFamily: 'Inter', fontSize: screenWidth * 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  TextFormField(
                    controller: emailController,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter email';
                      if (!_isValidEmail(v)) return 'Enter a valid business email';
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Mail Address (Business/Personal)",
                      labelStyle: TextStyle(fontFamily: 'Inter', fontSize: screenWidth * 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  ValueListenableBuilder<String>(
                    valueListenable: selectedCountryCode,
                    builder: (context, code, _) => TextFormField(
                      controller: contactController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter contact number';
                        if (!_isValidPhone(v)) return 'Enter a valid 10-digit phone number';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Contact Number",
                        labelStyle: TextStyle(fontFamily: 'Inter', fontSize: screenWidth * 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Padding(
                          padding:  EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.01),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: code,
                              items: ['+91', '+1', '+44', '+61', '+81', '+971']
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) selectedCountryCode.value = val;
                              },
                            ),
                          ),
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  TextFormField(
                    controller: socialController,
                    validator: (v) => v == null || v.isEmpty ? 'Enter social media link' : null,
                    decoration: InputDecoration(
                      labelText: "Company Social Media Link",
                      labelStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: screenWidth * 0.04,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.public),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  ValueListenableBuilder<bool>(
                    valueListenable: obscurePassword,
                    builder: (context, obscure, _) => TextFormField(
                      controller: passwordController,
                      obscureText: obscure,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter password';
                        if (!_isValidPassword(v)) return 'Password must be at least 8 chars, 1 uppercase, 1 special';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontFamily: 'Inter', fontSize: screenWidth * 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => obscurePassword.value = !obscurePassword.value,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  TextFormField(
                    controller: websiteController,
                    decoration: InputDecoration(
                      labelText: "Website Link (Optional)",
                      labelStyle: TextStyle(fontFamily: 'Inter', fontSize: screenWidth * 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.language),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        padding:  EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      onPressed: loading ? null : () => _submit(context),
                      child: loading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        "Create Account",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
