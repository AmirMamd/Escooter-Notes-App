import 'package:escooter_notes_app/managers/navigator/named_navigator.dart';
import 'package:escooter_notes_app/managers/navigator/named_navigator_implementation.dart';
import 'package:escooter_notes_app/screens/common/e_notes_common.dart';
import 'package:escooter_notes_app/screens/common/functions/snackbar_function.dart';
import 'package:escooter_notes_app/screens/common/widgets/e_loading_button.dart';
import 'package:escooter_notes_app/screens/common/widgets/t_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/colors.dart';
import '../../view_models/authentication/authentication_provider.dart';
import '../common/widgets/e_text_form_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPasswordInvisible = true;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    return ENotesCommon(
      screenContent: Form(
        key: _formKey,
        child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            padding: EdgeInsets.zero,
            children: [
              Column(
                children: [
                  Sizes.titleScreens.hSpacer,
                  Text(ETexts.login,
                      style: Theme.of(context).textTheme.displayMedium),
                  (2 * Sizes.spaceBetweenSections).hSpacer,
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
                    prefixIcon: const Icon(Icons.security, color: Colors.grey),
                    onToggleObscureText: () => setState(
                        () => isPasswordInvisible = !isPasswordInvisible),
                    obscureText: isPasswordInvisible,
                  ),
                  (2 * Sizes.spaceBetweenSections).hSpacer,
                  authProvider.isLoading != null &&
                          authProvider.isLoading == true
                      ? const ELoadingButton()
                      : EButton(
                          text: ETexts.login,
                          onPressed: () async => _handleLogin(context)),
                  Sizes.spaceBetweenButtons.hSpacer,
                  EButton(
                      text: ETexts.createAccount,
                      onPressed: () async =>
                          _handleSignUp(context, authProvider),
                      isStroke: true),
                  (2 * Sizes.spaceBetweenSections).hSpacer,
                ],
              ),
            ]),
      ),
    );
  }

  void _handleLogin(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        final emailText = email.text;
        final passwordText = password.text;

        final authProvider = context.read<AuthenticationProvider>();

        await authProvider.login(emailText, passwordText);

        if (authProvider.errorMessage != null && mounted) {
          showSnackBar(context, authProvider.errorMessage!);
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  void _handleSignUp(
      BuildContext context, AuthenticationProvider authProvider) async {
    try {
      authProvider.errorMessage = null;
      NamedNavigatorImpl().push(Routes.SIGN_UP_SCREEN);
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }
}
