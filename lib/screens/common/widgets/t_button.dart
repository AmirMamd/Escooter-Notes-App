import 'package:escooter_notes_app/utils/constants/sizes.dart';
import 'package:escooter_notes_app/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isStroke;

  const EButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isStroke = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Sizes.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            isStroke ? Colors.transparent : AppColors.primary,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0.r),
              side: BorderSide(
                color: AppColors.primary,
                width: isStroke ? 1.0 : 0.0, // Show border only for stroke mode
              ),
            ),
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 16.sp, // Customize as needed
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          foregroundColor: WidgetStateProperty.all<Color>(
            isStroke ? AppColors.white : Colors.white, // Text color
          ),
          overlayColor: WidgetStateProperty.all<Color>(
            AppColors.primary.withOpacity(0.1), // Ripple effect color
          ),
          elevation: WidgetStateProperty.all<double>(0), // Remove shadow
        ),
        child: Text(text),
      ),
    );
  }
}