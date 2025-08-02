import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class SubHeading extends StatelessWidget {
  final VoidCallback ondeleteAll;
  final int taskCount;
  const SubHeading(
      {super.key, required this.ondeleteAll, required this.taskCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Total Tasks: $taskCount",
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            overlayColor: taskCount == 0 ? Colors.transparent : blackColor,
          ),
          onPressed: taskCount == 0
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (context) => _buildConfirmationDialog(context),
                  );
                },
          child: Text(
            "Delete All",
            style: GoogleFonts.poppins(
              color: taskCount == 0 ? greyColor : blackColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: bgColor,
      title: Text(
        'Delete all tasks?',
        style: GoogleFonts.raleway(
          color: blackColor,
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
              color: blackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            ondeleteAll();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            overlayColor: bgColor,
            backgroundColor: blackColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Delete',
            style: GoogleFonts.raleway(
              color: bgColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
