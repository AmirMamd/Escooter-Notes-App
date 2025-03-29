import 'package:escooter_notes_app/screens/common/e_notes_common.dart';
import 'package:escooter_notes_app/screens/common/widgets/t_button.dart';
import 'package:escooter_notes_app/view_model/authentication/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../utils/constants/sizes.dart';
import '../common/widgets/e_text_form_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPasswordVisible = false;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    return ENotesCommon(
      screenContent: Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              'Login',
              style: Theme.of(context).textTheme.displayMedium
            ),

            (3 * Sizes.spaceBetweenSections).hSpacer,

            ETextFormField(
              controller: email,
              labelText: 'Email',
              prefixIcon: const Icon(Icons.person_outline_sharp, color: Colors.grey),
            ),

            Sizes.spaceBetweenInputFields.hSpacer,

            ETextFormField(
              controller: password,
              labelText: 'Password',
              prefixIcon: const Icon(Icons.security, color: Colors.grey),
              isPasswordField: !isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.remove_red_eye_sharp : Icons.visibility_off_sharp,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            (2 * Sizes.spaceBetweenSections).hSpacer,

            authProvider.isLoading
                ? const CircularProgressIndicator()
                : EButton(
              text: 'Login',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  authProvider.login(email.text, password.text);
                }
              },
            ),

            Sizes.spaceBetweenInputFields.hSpacer,

            EButton(text: 'Create Account', onPressed: (){}, isStroke: true),

            (2 * Sizes.spaceBetweenSections).hSpacer,
          ],
        ),
      );
  }
}
