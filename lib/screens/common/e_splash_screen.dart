import 'package:escooter_notes_app/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../managers/navigator/named_navigator.dart';
import '../../managers/navigator/named_navigator_implementation.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/colors.dart';

class ESplashScreen extends StatefulWidget {
  const ESplashScreen({super.key});

  @override
  _ESplashScreenState createState() => _ESplashScreenState();
}

class _ESplashScreenState extends State<ESplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeTextAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigation(); // Safe to use context here
    });
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _fadeTextAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 3), () {
      setState(() {
        _controller.repeat(reverse: true);
      });
    });
  }

  Future<void> _handleNavigation() async {
    Future.delayed(const Duration(seconds: 3), () async {
      bool isLoggedIn =
          await context.read<AuthenticationRepository>().isLoggedIn();
      if (isLoggedIn) {
        NamedNavigatorImpl().push(Routes.NOTES_SCREEN, clean: true);
      } else {
        NamedNavigatorImpl().push(Routes.LOGIN_SCREEN, clean: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _fadeTextAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeTextAnimation.value,
                  child: Text(
                    ETexts.splashWelcomeText,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                );
              },
            ),
            Lottie.asset('${ImageStrings.animations}/splash_screen.json'),
          ],
        ),
      ),
    );
  }
}
