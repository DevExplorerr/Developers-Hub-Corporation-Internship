// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:auth_connect/global/toast.dart';
import 'package:auth_connect/screens/change_password_screen.dart';
import 'package:auth_connect/screens/delete_account_screen.dart';
import 'package:auth_connect/screens/login_screen.dart';
import 'package:auth_connect/screens/update_username_screen.dart';
import 'package:auth_connect/services/auth_service.dart';
import 'package:auth_connect/widgets/colors.dart';
import 'package:auth_connect/widgets/profile_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = authservice.value.currentUser!.uid;

    return Scaffold(
      backgroundColor: whiteColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                "No user data found",
                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 50, bottom: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                profilePic(),
                const SizedBox(height: 20),

                // User name
                Text(
                  userData["name"] ??
                      authservice.value.currentUser!.displayName ??
                      "",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                  ),
                ),

                const SizedBox(height: 5),

                // User email
                Text(
                  userData["email"] ??
                      authservice.value.currentUser!.email ??
                      "",
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    color: secondaryColor.withOpacity(0.75),
                  ),
                ),

                const SizedBox(height: 25),

                // Profile Menu items
                ProfileMenu(
                  text: "Update Username",
                  icon: Icons.text_fields,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdateUsernameScreen(
                          userName:
                              userData["name"] ??
                              authservice.value.currentUser!.displayName ??
                              "",
                        ),
                      ),
                    );
                  },
                ),
                ProfileMenu(
                  text: "Notifications",
                  icon: Icons.notifications,
                  press: () {},
                ),
                ProfileMenu(
                  text: "Change Password",
                  icon: Icons.password,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenu(
                  text: "Delete my account",
                  icon: Icons.delete_forever_rounded,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DeleteAccountScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenu(
                  text: "Log Out",
                  icon: Icons.logout,
                  press: () {
                    showLogoutDialog(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget profilePic() {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundColor: primaryColor.withOpacity(0.7),
            child: Icon(Icons.person, color: blackColor, size: 50),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: whiteColor),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: const Icon(Icons.camera_alt, color: blackColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
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

            void logout() async {
              try {
                setStateDialog(() {
                  isLoading = true;
                });
                await authservice.value.signOut();
                showToast(message: "Logged out successfully");
                await Future.delayed(const Duration(seconds: 1));
                Navigator.pop(dialogContext);
                navigateToLoginScreen();
              } on FirebaseAuthException catch (e) {
                showToast(message: e.message.toString());
              }
            }

            return AlertDialog(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Confirm Logout",
                style: GoogleFonts.poppins(color: blackColor),
              ),
              content: Text(
                "Are you sure you want to log out?",
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
                  onPressed: isLoading ? null : logout,
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
                          "Logout",
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
