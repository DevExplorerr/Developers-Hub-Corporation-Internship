import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/colors.dart';
import 'custom_searchbar.dart';

class CustomAppbar extends StatelessWidget {
  final Function(String) onAddTask;
  final Function(String) onSearchChanged;
  final String userName;
  const CustomAppbar({super.key, required this.onAddTask, required this.onSearchChanged, required this.userName});

  @override
  Widget build(BuildContext context) {
      String formattedDate = DateFormat('yMMMMd').format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome $userName",
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
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
          onAddTask: onAddTask, onSearchChanged: onSearchChanged
        ),
      ],
    );
  }
}
