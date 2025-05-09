import 'package:escooter_notes_app/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';

class ETextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final VoidCallback? onToggleObscureText;
  final bool? obscureText;
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
    this.obscureText,
    this.onToggleObscureText,
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
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.grey,
          cursorColor: AppColors.white,
          selectionHandleColor: Colors.grey,
        ),
      ),
      child: TextFormField(
        style: TextStyle(
          color: AppColors.white,
          fontSize: Sizes.md,
          fontFamily: '',
        ),
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        maxLength: maxLength,
        maxLines: maxLines,
        autofocus: autofocus,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          suffixIcon: onToggleObscureText != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: Transform.scale(
                    scale: 0.65,
                    child: IconButton(
                      icon: Icon(
                        obscureText! ? Iconsax.eye_slash : Iconsax.eye,
                        color: AppColors.grey,
                      ),
                      onPressed: onToggleObscureText,
                    ),
                  ),
                )
              : suffixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Transform.scale(
                        scale: 0.65,
                        child: suffixIcon,
                      ),
                    )
                  : null,
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Transform.scale(scale: 1, child: prefixIcon),
          ),
          labelStyle: TextStyle(
            color: AppColors.white,
            fontSize: Sizes.md,
          ),
          floatingLabelStyle:
              TextStyle(color: AppColors.white, fontSize: Sizes.md),
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.0.h, horizontal: 10.w),
          errorStyle: TextStyle(fontSize: 12.sp),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.white, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.white, width: 1),
          ),
          border: borderStyle ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Colors.grey),
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
      ),
    );
  }
}
