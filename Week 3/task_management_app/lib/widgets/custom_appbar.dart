import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/auth/auth_service.dart';
import 'package:task_management_app/widgets/colors.dart';
import 'package:task_management_app/global/toast.dart';
import '../auth/login_screen.dart';
import 'custom_searchbar.dart';

class CustomAppbar extends StatelessWidget {
  final Function(String) onAddTask;
  final Function(String) onSearchChanged;

  CustomAppbar({
    super.key,
    required this.onAddTask,
    required this.onSearchChanged,
  });

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yMMMMd').format(DateTime.now());
    final displayName = user?.displayName ?? 'Guest';
    final AuthService authService = AuthService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Welcome $displayName",
              style: GoogleFonts.poppins(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(overlayColor: blackColor),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        _buildDialogBox(context, authService));
              },
              icon: Icon(
                Icons.logout_sharp,
                color: inputIconColor,
                size: 24.sp,
              ),
            ),
          ],
        ),
        Text(
          formattedDate,
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 30.h),
        CustomSearchBar(
          onAddTask: onAddTask,
          onSearchChanged: onSearchChanged,
        ),
      ],
    );
  }

  Widget _buildDialogBox(BuildContext context, AuthService authService) {
    return AlertDialog(
      backgroundColor: bgColor,
      title: Text(
        'Are you sure you want to logout?',
        style: GoogleFonts.raleway(
          color: textColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(overlayColor: blackColor),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.raleway(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await authService.logout();
            showToast(message: "Successfully logged out");
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            overlayColor: bgColor,
            backgroundColor: primaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Logout',
            style: GoogleFonts.inter(
              color: primaryButtonTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
