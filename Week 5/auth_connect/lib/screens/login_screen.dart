// ignore_for_file: use_build_context_synchronously

import 'package:auth_connect/global/toast.dart';
import 'package:auth_connect/screens/profile_screen.dart';
import 'package:auth_connect/screens/reset_password.dart';
import 'package:auth_connect/screens/signup_screen.dart';
import 'package:auth_connect/services/auth_service.dart';
import 'package:auth_connect/widgets/colors.dart';
import 'package:auth_connect/widgets/custom_button.dart';
import 'package:auth_connect/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;
  String errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    try {
      if (emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        setState(() {
          errorMessage = "Please enter email and password";
        });
      }
      await authservice.value.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      showToast(message: "Login successfully");
      navigateToProfileScreen();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: "Invalid email or password.");
      } else {
        showToast(message: "Error: ${e.code}");
      }
      setState(() {
        errorMessage = e.message ?? "This is not working";
      });
    }
  }

  void navigateToProfileScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "Welcome Back",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in with your email and password",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(color: secondaryColor),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  CustomTextfield(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email, color: secondaryColor),
                    controller: emailController,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  CustomTextfield(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    obsecureText: obsecureText,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecureText = !obsecureText;
                        });
                      },
                      icon: Icon(
                        obsecureText ? Icons.visibility_off : Icons.visibility,
                        color: secondaryColor,
                      ),
                    ),
                    controller: passwordController,
                  ),

                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResetPassword(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    errorMessage,
                    style: GoogleFonts.rubik(color: Colors.redAccent),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  CustomButton(
                    onPressed: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      await login();
                    },
                    text: 'Login',
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  noAccountText(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget noAccountText(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Don’t have an account? ",
        style: GoogleFonts.rubik(color: secondaryColor),
      ),
      GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SignupScreen()),
          );
        },
        child: Text(
          "Sign Up",
          style: GoogleFonts.rubik(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}
