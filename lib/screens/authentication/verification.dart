import 'package:escooter_notes_app/screens/authentication/widgets/pin_code_input.dart';
import 'package:escooter_notes_app/utils/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/colors.dart';
import '../../view_models/authentication/authentication_provider.dart';
import '../common/functions/snackbar_function.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (authProvider.errorMessage != null) {
          showSnackBar(context, authProvider.errorMessage!);
          authProvider.errorMessage = null;
        } else if (authProvider.successMessage != null) {
          showSnackBar(context, authProvider.successMessage!,
              messageType: MessageType.success);
          authProvider.successMessage = null;
        }
      });
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SafeArea(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
                  children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Sizes.defaultSpace), // Top Padding

                    // Image
                    Icon(Iconsax.security, size: 120.sp, color: Colors.white),
                    SizedBox(height: Sizes.spaceBetweenItems),

                    // Title & Subtitle
                    Text(
                      ETexts.verificationCodeTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Sizes.spaceBetweenItems),

                    Text(
                      ETexts.verificationCodeSubtitle,
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Sizes.spaceBetweenItems),

                    // PIN Input
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: const PinInput(),
                        ),
                        SizedBox(height: Sizes.spaceBetweenItems / 1.5),
                        authProvider.isLoading != null &&
                                authProvider.isLoading == true
                            ? const CircularProgressIndicator(
                                color: AppColors.primary)
                            : GestureDetector(
                                onTap: () {
                                  context
                                      .read<AuthenticationProvider>()
                                      .resendOtp();
                                },
                                child: Text("Resend code",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white,
                                          // 👈 Set underline color
                                          color: Colors.white,
                                        )),
                              ),
                      ],
                    ),
                  ],
                )
              ])),
        ),
      );
    });
  }
}
