import 'package:escooter_notes_app/screens/authentication/widgets/phone_with_country_code.dart';
import 'package:escooter_notes_app/screens/common/e_notes_common.dart';
import 'package:escooter_notes_app/screens/common/functions/snackbar_function.dart';
import 'package:escooter_notes_app/screens/common/widgets/e_loading_button.dart';
import 'package:escooter_notes_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/theme/colors.dart';
import '../../view_models/authentication/authentication_provider.dart';
import '../common/widgets/e_text_form_field.dart';
import '../common/widgets/t_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isPasswordInvisible = true;
  bool isConfirmPasswordInvisible = true;
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumberText = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (authProvider.errorMessage != null && mounted) {
          showSnackBar(context, authProvider.errorMessage!);
          // Clear the error after showing it
          authProvider.errorMessage = null;
        }
      });
      return ENotesCommon(
          appBarTitle: ETexts.createAccount,
          appBarLeadingIcon:
              const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          screenContent: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                // Disable scrolling
                padding: EdgeInsets.zero,
                children: [
                  Column(
                    children: [
                      Sizes.spaceBetweenSections.hSpacer,
                      ETextFormField(
                        controller: firstName,
                        labelText: ETexts.firstName,
                        prefixIcon: Icon(
                          Iconsax.user,
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                      ),
                      Sizes.spaceBetweenInputFields.hSpacer,
                      ETextFormField(
                        controller: lastName,
                        labelText: ETexts.lastName,
                        prefixIcon: Icon(
                          Iconsax.user,
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                      ),
                      Sizes.spaceBetweenInputFields.hSpacer,
                      ETextFormField(
                        controller: email,
                        labelText: ETexts.email,
                        prefixIcon: Icon(Iconsax.direct_right,
                            color: AppColors.grey, size: 20.sp),
                      ),
                      Sizes.spaceBetweenInputFields.hSpacer,
                      ETextFormField(
                        controller: password,
                        labelText: ETexts.password,
                        prefixIcon:
                            const Icon(Icons.security, color: Colors.grey),
                        onToggleObscureText: () => setState(
                            () => isPasswordInvisible = !isPasswordInvisible),
                        obscureText: isPasswordInvisible,
                      ),
                      Sizes.spaceBetweenInputFields.hSpacer,
                      ETextFormField(
                        controller: confirmPassword,
                        labelText: ETexts.confirmPassword,
                        prefixIcon:
                            const Icon(Icons.security, color: Colors.grey),
                        onToggleObscureText: () => setState(() =>
                            isConfirmPasswordInvisible =
                                !isConfirmPasswordInvisible),
                        obscureText: isConfirmPasswordInvisible,
                      ),
                      Sizes.spaceBetweenInputFields.hSpacer,
                      PhoneWithCountryCode(controller: phoneNumberText),
                      (2 * Sizes.spaceBetweenSections).hSpacer,
                      authProvider.isLoading != null &&
                              authProvider.isLoading == true
                          ? const ELoadingButton()
                          : EButton(
                              text: ETexts.createAccount,
                              onPressed: () async {
                                _handleSignUp(context);
                              },
                            ),
                      (2 * Sizes.spaceBetweenSections).hSpacer,
                    ],
                  )
                ],
              )));
    });
  }

  void _handleSignUp(BuildContext context) {
    try {
      if (_formKey.currentState!.validate()) {
        final firstNameText = firstName.text;
        final lastNameText = lastName.text;
        final emailText = email.text;
        final passwordText = password.text;
        final confirmPasswordText = confirmPassword.text;
        final phoneNumber = phoneNumberText.text;
        final authProvider = context.read<AuthenticationProvider>();
        if (passwordText != confirmPasswordText) {
          showSnackBar(context, ETexts.passwordMissMatch);
        } else {
          authProvider.createAccount(emailText, passwordText,
              "$firstNameText $lastNameText", phoneNumber);
          if (mounted && authProvider.errorMessage != null) {
            showSnackBar(context, authProvider.errorMessage!);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }
}
