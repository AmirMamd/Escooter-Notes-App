import 'package:escooter_notes_app/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ENotesCommon extends StatelessWidget {
  final String? appBarTitle;
  final Icon? appBarLeadingIcon;
  final IconButton? appBarIconButton;
  final Widget screenContent;
  final Widget? bottomNavigationBar;

  const ENotesCommon(
      {super.key,
      this.appBarTitle,
      this.appBarLeadingIcon,
      this.appBarIconButton,
      required this.screenContent,
      this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text(appBarTitle ?? '',
            style: Theme.of(context).textTheme.displaySmall),
        leading: appBarIconButton ??
            (appBarLeadingIcon != null
                ? IconButton(
                    icon: appBarLeadingIcon!,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                : null),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: screenContent,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
