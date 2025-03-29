import 'package:escooter_notes_app/repositories/authentication_repository.dart';
import 'package:escooter_notes_app/repositories/user_repository.dart';
import 'package:escooter_notes_app/services/app_write_service.dart';
import 'package:escooter_notes_app/utils/config/config.dart';
import 'package:escooter_notes_app/utils/helpers/helpers.dart';
import 'package:escooter_notes_app/screens/common/e_splash_screen.dart';
import 'package:escooter_notes_app/utils/theme/app_theme.dart';
import 'package:escooter_notes_app/view_model/authentication/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'managers/navigator/named_navigator_implementation.dart';

void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();
  Helpers.setOrientationToPortrait();
  final appwriteService = AppwriteService();
  await AppwriteConfig.load();
  final authRepository = AuthenticationRepository(appwriteService);
  final userRepository = UserRepository(appwriteService);
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthenticationProvider(authRepository, userRepository)),
      
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
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const ESplashScreen(),
          navigatorKey: NamedNavigatorImpl.navigatorState,
          onGenerateRoute: NamedNavigatorImpl.onGenerateRoute,
        );
      },
    );
  }
}