import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../utils/theme/colors.dart';
import '../../../view_models/authentication/authentication_provider.dart';

class PinInput extends StatefulWidget {
  const PinInput({super.key});

  @override
  State<PinInput> createState() => PinInputState();
}

class PinInputState extends State<PinInput> {
  final verificationCode = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    verificationCode.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(255, 255, 255, 0.4);
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: AppColors.white,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: Pinput(
              length: 4,
              controller: verificationCode,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => SizedBox(width: 8.w),
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                context
                    .read<AuthenticationProvider>()
                    .verifyOtp(verificationCode.text);
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 9.h),
                    width: 22.w,
                    height: 1.h,
                    color: AppColors.white,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8.sp),
                  border: Border.all(color: AppColors.white),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19.sp),
                  border: Border.all(color: AppColors.white),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          SizedBox(height: Sizes.spaceBetweenInputFields),
        ],
      ),
    );
  }
}
