import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_app/widgets/colors.dart';

class CustomButton extends StatefulWidget {
  final Function(String) onAddTask;
  const CustomButton({
    super.key,
    required this.onAddTask,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _buildDialogBox(context, titleController.text),
        );
      },
      child: Container(
        height: 45.h,
        width: 55.w,
        decoration: BoxDecoration(
          color: primaryButtonColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            "Add",
            style: GoogleFonts.inter(
              color: primaryButtonTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogBox(BuildContext context, String taskTitle) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        backgroundColor: bgColor,
        title: Text(
          'Add New Task',
          style: GoogleFonts.raleway(
            color: textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: GoogleFonts.raleway(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 5.h),
            TextField(
              controller: titleController,
              cursorColor: blackColor,
              decoration: InputDecoration(
                hintText: 'Add task here...',
                hintStyle: GoogleFonts.podkova(
                  color: inputHintTextColor,
                  fontSize: 17.sp,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: inputBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: blackColor),
                ),
              ),
              style: GoogleFonts.podkova(color: textColor),
            ),
          ],
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
            onPressed: () {
              final taskTitle = titleController.text;
              if (taskTitle.trim().isEmpty) return;
              widget.onAddTask(taskTitle);
              titleController.clear();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              overlayColor: bgColor,
              backgroundColor: primaryButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Add',
              style: GoogleFonts.inter(
                color: primaryButtonTextColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
