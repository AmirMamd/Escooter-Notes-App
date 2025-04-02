import 'package:escooter_notes_app/managers/caching/security.dart';
import 'package:escooter_notes_app/managers/navigator/named_navigator_implementation.dart';
import 'package:escooter_notes_app/repositories/authentication_repository.dart';
import 'package:escooter_notes_app/repositories/notes_repository.dart';
import 'package:escooter_notes_app/repositories/user_repository.dart';
import 'package:escooter_notes_app/services/app_write_service.dart';
import 'package:escooter_notes_app/services/email_service.dart';
import 'package:escooter_notes_app/services/user_service.dart';
import 'package:escooter_notes_app/utils/config/config.dart';
import 'package:escooter_notes_app/utils/connectivity/connectivity.dart';
import 'package:escooter_notes_app/utils/helpers/helpers.dart';
import 'package:escooter_notes_app/utils/theme/app_theme.dart';
import 'package:escooter_notes_app/view_models/authentication/authentication_provider.dart';
import 'package:escooter_notes_app/view_models/notes/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Helpers.setOrientationToPortrait();
  await AppwriteConfig.load();
  final appwriteService = AppwriteService();
  final emailService = EmailService();
  final userService = UserService();
  final authRepository = AuthenticationRepository(
      appwriteService, emailService, SecureStorage(), userService);
  final userRepository = UserRepository(appwriteService);
  final notesRepository = NotesRepository(appwriteService);

  runApp(MultiProvider(
    providers: [
      Provider<AuthenticationRepository>.value(value: authRepository),
      Provider<UserRepository>.value(value: userRepository),
      Provider<NotesRepository>.value(value: notesRepository),
      ChangeNotifierProvider(
        create: (_) => AuthenticationProvider(authRepository, userRepository),
      ),
      ChangeNotifierProvider(
        create: (_) => NotesProvider(notesRepository,
            DefaultConnectivityChecker(SecureStorage()), SecureStorage()),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: goRouter,
        );
      },
    );
  }
}
