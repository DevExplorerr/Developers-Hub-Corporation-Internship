// ignore_for_file: use_build_context_synchronously

import 'package:auth_connect/global/toast.dart';
import 'package:auth_connect/screens/login_screen.dart';
import 'package:auth_connect/screens/profile_screen.dart';
import 'package:auth_connect/services/auth_service.dart';
import 'package:auth_connect/widgets/colors.dart';
import 'package:auth_connect/widgets/custom_button.dart';
import 'package:auth_connect/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;
  String errorMessage = "";

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    try {
      if (nameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        setState(() {
          errorMessage = "Please fil in all fields";
        });
      }
      await authservice.value.signUp(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      );
      showToast(message: "Registration successful");
      navigateToProfileScreen();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: "The email is already in use.");
      } else {
        showToast(message: "Error: ${e.code}");
      }
      setState(() {
        errorMessage = e.message ?? "There is an error";
      });
    }
  }

  void navigateToProfileScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen()),
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
                    "Register Account",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Complete your details",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(color: secondaryColor),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  CustomTextfield(
                    hintText: 'Enter your name',
                    labelText: 'Name',
                    keyboardType: TextInputType.name,
                    prefixIcon: Icon(Icons.person, color: secondaryColor),
                    controller: nameController,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  CustomTextfield(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email, color: secondaryColor),
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
                  const SizedBox(height: 10),
                  Text(
                    errorMessage,
                    style: GoogleFonts.rubik(color: Colors.redAccent),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  CustomButton(
                    onPressed: () async {
                      await Future.delayed(const Duration(milliseconds: 1));
                      await register();
                    },
                    text: 'Register',
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

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: secondaryColor),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);

Widget noAccountText(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Already have an account? ",
        style: GoogleFonts.rubik(color: secondaryColor),
      ),
      GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        child: Text(
          "Login",
          style: GoogleFonts.rubik(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}
