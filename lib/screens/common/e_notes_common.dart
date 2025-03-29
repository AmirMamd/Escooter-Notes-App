import 'package:escooter_notes_app/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ENotesCommon extends StatelessWidget {
  final String? appBarTitle;
  final Icon? appBarLeadingIcon;
  final Widget screenContent;
  const ENotesCommon({
    super.key,
    this.appBarTitle,
    this.appBarLeadingIcon,
    required this.screenContent,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, centerTitle: true,
        title: Text(
          appBarTitle ?? '',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: screenContent,
      )
    );
  }
}
