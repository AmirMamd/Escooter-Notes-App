import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/theme/colors.dart';

class ELoadingButton extends StatelessWidget {
  const ELoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.buttonHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SizedBox(
          height: 20.h,
          width: 20.w,
          child: const CircularProgressIndicator(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
