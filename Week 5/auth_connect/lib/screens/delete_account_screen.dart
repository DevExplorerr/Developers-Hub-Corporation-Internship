// ignore_for_file: use_build_context_synchronously

import 'package:auth_connect/global/toast.dart';
import 'package:auth_connect/screens/login_screen.dart';
import 'package:auth_connect/services/auth_service.dart';
import 'package:auth_connect/widgets/colors.dart';
import 'package:auth_connect/widgets/custom_button.dart';
import 'package:auth_connect/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;

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

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                      Icons.delete_forever,
                      size: 80,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Delete my account",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextfield(
                    hintText: "Email",
                    labelText: "Enter your email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email, color: secondaryColor),
                  ),
                  const SizedBox(height: 25),
                  CustomTextfield(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    obsecureText: obsecureText,
                    controller: passwordController,
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
                  ),
                  const SizedBox(height: 35),
                  CustomButton(
                    onPressed: () async {
                      showDeleteAccountDialog(context);
                    },
                    text: "Delete Permanently",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteAccountDialog(BuildContext context) {
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      animationStyle: AnimationStyle(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 200),
      ),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            void navigateToLoginScreen() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }

            Future<void> deleteAccount() async {
              try {
                setStateDialog(() {
                  isLoading = true;
                });

                await authservice.value.deleteAccount(
                  email: emailController.text,
                  password: passwordController.text,
                );
                showToast(message: "Account deleted successfully");

                await Future.delayed(const Duration(seconds: 1));
                Navigator.pop(dialogContext);
                navigateToLoginScreen();
              } on FirebaseAuthException catch (e) {
                showToast(message: e.message.toString());
                setStateDialog(() {
                  isLoading = false;
                });
              }
            }

            return AlertDialog(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Delete Account",
                style: GoogleFonts.poppins(color: primaryColor),
              ),
              content: Text(
                "Are you sure you want to delete your account? This action cannot be undone.",
                style: GoogleFonts.rubik(color: blackColor),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.rubik(color: secondaryColor),
                  ),
                ),
                TextButton(
                  onPressed: isLoading ? null : deleteAccount,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        )
                      : Text(
                          "Delete",
                          style: GoogleFonts.rubik(color: primaryColor),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
