import 'package:auth_connect/global/toast.dart';
import 'package:auth_connect/screens/profile_screen.dart';
import 'package:auth_connect/services/auth_service.dart';
import 'package:auth_connect/widgets/colors.dart';
import 'package:auth_connect/widgets/custom_button.dart';
import 'package:auth_connect/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  bool obsecureText = true;
  bool obsecuretext = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

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

  Future<void> updatePassword() async {
    try {
      await authservice.value.resetPasswodFromCurrentPassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        email: emailController.text,
      );
      showToast(message: "Password Changed Successfully");
      navigateToProfileScreen();
    } catch (e) {
      showToast(message: "Password Change Failed");
    }
  }

  void navigateToProfileScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    newPasswordController.dispose();
    currentPasswordController.dispose();
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
                    child: Icon(Icons.lock, size: 80, color: primaryColor),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Change Password",
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
                    hintText: "Current Password",
                    labelText: "Enter current password",
                    controller: currentPasswordController,
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
                  ),
                  const SizedBox(height: 25),
                  CustomTextfield(
                    hintText: "New Password",
                    labelText: "Enter new password",
                    controller: newPasswordController,
                    keyboardType: TextInputType.visiblePassword,
                    obsecureText: obsecuretext,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecuretext = !obsecuretext;
                        });
                      },
                      icon: Icon(
                        obsecuretext ? Icons.visibility_off : Icons.visibility,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  CustomButton(
                    onPressed: () async {
                      await updatePassword();
                    },
                    text: "Change Password",
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
