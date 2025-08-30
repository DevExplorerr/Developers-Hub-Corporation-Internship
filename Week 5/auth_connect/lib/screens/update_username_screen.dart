import 'package:auth_connect/global/toast.dart';
import 'package:auth_connect/screens/profile_screen.dart';
import 'package:auth_connect/services/auth_service.dart';
import 'package:auth_connect/widgets/colors.dart';
import 'package:auth_connect/widgets/custom_button.dart';
import 'package:auth_connect/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateUsernameScreen extends StatefulWidget {
  final String userName;
  const UpdateUsernameScreen({super.key, required this.userName});

  @override
  State<UpdateUsernameScreen> createState() => _UpdateUsernameScreenState();
}

class _UpdateUsernameScreenState extends State<UpdateUsernameScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController userNameController = TextEditingController();

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
    userNameController.text = widget.userName;
  }

  Future<void> updateUsername() async {
    try {
      await authservice.value.updateUsername(userName: userNameController.text);
      if (userNameController.text.isNotEmpty) {
        showToast(message: "Username Changed Successfully");
        navigateToProfileScreen();
      } else {
        showToast(message: "Please enter a valid username");
      }
    } catch (e) {
      showToast(message: "Username Change Failed");
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
    userNameController.dispose();
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
                      Icons.text_fields,
                      size: 80,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Update username",
                    style: GoogleFonts.poppins(
                      color: blackColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextfield(
                    hintText: "Enter new username",
                    labelText: "User Name",
                    controller: userNameController,
                    keyboardType: TextInputType.name,
                    prefixIcon: Icon(Icons.text_fields, color: secondaryColor),
                  ),
                  const SizedBox(height: 35),
                  CustomButton(
                    onPressed: () async {
                      await updateUsername();
                    },
                    text: "Update Username",
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
