import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class CustomListTile extends StatefulWidget {
  final String taskTitle;
  final VoidCallback onDelete;
  final ValueChanged<String> onEdit;
  final bool isCompleted;
  final ValueChanged<bool> onStatusToggle;
  const CustomListTile(
      {super.key,
      required this.taskTitle,
      required this.onDelete,
      required this.onEdit,
      required this.isCompleted,
      required this.onStatusToggle});

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: inputBorderColor, width: 1),
      ),
      child: ListTile(
        minTileHeight: 40.h,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        tileColor: bgColor,
        title: GestureDetector(
          onTap: () {
            showModalBottomSheet(
                elevation: 10,
                backgroundColor: bgColor,
                showDragHandle: true,
                isScrollControlled: true,
                context: context,
                builder: (context) => _buildBottomSheet(context));
          },
          child: Text(
            widget.taskTitle,
            style: GoogleFonts.poppins(
              color:
                  widget.isCompleted ? listViewCompletedTextColor : textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              decoration: widget.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        leading: IconButton(
          style: IconButton.styleFrom(overlayColor: blackColor),
          onPressed: () {
            setState(() {
              widget.onStatusToggle(!widget.isCompleted);
            });
          },
          icon: Icon(
            widget.isCompleted
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: widget.isCompleted
                ? listViewCheckBoxColor
                : listViewUnfillCheckBoxColor,
            size: 28.sp,
          ),
        ),
        trailing: IconButton(
          style: IconButton.styleFrom(overlayColor: blackColor),
          onPressed: widget.onDelete,
          icon: Icon(
            Icons.close_sharp,
            color: listViewDeleteIconColor,
            size: 28.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: widget.taskTitle);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Task",
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: controller,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Edit your task...',
                  hintStyle: GoogleFonts.podkova(
                    color: inputHintTextColor,
                    fontSize: 17.sp,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: inputBorderColor),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: blackColor),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                style: GoogleFonts.podkova(color: textColor),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      overlayColor: blackColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel",
                        style: GoogleFonts.poppins(color: textColor)),
                  ),
                  SizedBox(width: 10.w),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        widget.onEdit(controller.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      overlayColor: bgColor,
                      backgroundColor: primaryButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: GoogleFonts.inter(
                        color: primaryButtonTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
