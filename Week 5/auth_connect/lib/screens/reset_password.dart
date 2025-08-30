import 'package:auth_connect/global/toast.dart';
import 'package:auth_connect/screens/login_screen.dart';
import 'package:auth_connect/services/auth_service.dart';
import 'package:auth_connect/widgets/colors.dart';
import 'package:auth_connect/widgets/custom_button.dart';
import 'package:auth_connect/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  String errorMessage = '';

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  Future<void> resetPassword() async {
    try {
      await authservice.value.resetPassword(email: emailController.text);
      showToast(message: "Please check your email");
      setState(() {
        errorMessage = '';
      });
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "This is not working";
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: blackColor),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Reset Password",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter your email to receive a reset link",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: secondaryColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 35),
                  CustomTextfield(
                    hintText: "Email",
                    labelText: "Enter your email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email, color: secondaryColor),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    errorMessage,
                    style: GoogleFonts.rubik(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    onPressed: () async {
                      await resetPassword();
                    },
                    text: "Reset Password",
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
