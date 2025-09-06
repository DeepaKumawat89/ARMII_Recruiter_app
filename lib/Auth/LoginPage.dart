import 'package:flutter/material.dart';
import 'CreateAccountPage.dart';
import '../Screens/DashBoardScreens/HomePage.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const LoadingOverlay({required this.isLoading, required this.child, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // main screen
        if (isLoading) ...[
          Opacity(
            opacity: 0.6,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ]
      ],
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthProvider authProvider = AuthProvider();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ValueListenableBuilder<bool>(
      valueListenable: _loading,
      builder: (context, loading, _) => LoadingOverlay(
        isLoading: loading,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.07),
            child: AppBar(
              backgroundColor: Colors.indigo,
              centerTitle: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
              title: Text(
                "Get Started",
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 4,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // go back
                },
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:  EdgeInsets.all(screenWidth * 0.05),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         SizedBox(height: screenHeight * 0.06 ),
                        // Welcome Text
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                         SizedBox(height: screenHeight * 0.01),
                        Text(
                          "Login to continue using the app",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: screenWidth * 0.045,
                            color: Colors.grey[700],
                          ),
                        ),
                         SizedBox(height: screenHeight * 0.04),
                        // Email Field
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                         SizedBox(height: screenHeight * 0.02),
                        // Password Field
                        ValueListenableBuilder<bool>(
                          valueListenable: _obscurePassword,
                          builder: (context, obscure, _) => TextFormField(
                            controller: passwordController,
                            obscureText: obscure,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  _obscurePassword.value = !_obscurePassword.value;
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                         SizedBox(height: screenHeight * 0.02),
                        // Login Button
                        SizedBox(
                          width: screenWidth * 0.9,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              padding:  EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 3,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _loading.value = true;
                                await authProvider.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                                _loading.value = false;
                                if (authProvider.user != null) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                        (route) => false,
                                  );
                                } else if (authProvider.error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(authProvider.error!),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(screenWidth * 0.05),
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding:  EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      context.read<AppState>().increment();
                      print('Create New Account pressed, counter: '
                        '${context.read<AppState>().counter}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAccountPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Create New Account",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: screenWidth * 0.045,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
