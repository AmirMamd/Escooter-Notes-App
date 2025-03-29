import 'package:escooter_notes_app/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/helpers/helpers.dart';
import '../../../utils/constants/sizes.dart';

class ETextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final bool isPasswordField;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool autofocus;
  final int? maxLength;
  final int maxLines;
  final TextInputAction? textInputAction;
  final InputBorder? borderStyle;

  const ETextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPasswordField = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.maxLength,
    this.maxLines = 1,
    this.textInputAction,
    this.borderStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Helpers.isTablet(context);
    final size = isTablet ? 0.5.sp : 1;
    return TextFormField(
      style: TextStyle(
        color: AppColors.white,
        fontSize: Sizes.md,
      ),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPasswordField,
      maxLength: maxLength,
      maxLines: maxLines,
      autofocus: autofocus,
      textInputAction: textInputAction,
      cursorColor: AppColors.white,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: Transform.scale(scale: size.toDouble(), child: prefixIcon),
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child:
              Transform.scale(scale: size.toDouble() * 0.65, child: suffixIcon),
        ),
        labelStyle: TextStyle(
          color: AppColors.white,
          fontSize: Sizes.md,
        ),
        floatingLabelStyle: TextStyle(
          color: AppColors.grey,
          fontSize: Sizes.md
        ),
        contentPadding:
            EdgeInsets.symmetric(vertical: 15.0.h, horizontal: 10.w),
        errorStyle: TextStyle(
          fontSize: 12.sp,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: AppColors.white,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder( // Add this for unfocused state
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: AppColors.white, // White border when unfocused
            width: 1,
          ),
        ),
        border: borderStyle ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty';
            }
            return null;
          },
      onChanged: onChanged,
    );
  }
}
