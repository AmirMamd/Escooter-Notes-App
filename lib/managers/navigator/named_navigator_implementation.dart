import 'package:escooter_notes_app/screens/authentication/login.dart';
import 'package:escooter_notes_app/screens/authentication/sign_up.dart';
import 'package:escooter_notes_app/screens/authentication/verification.dart';
import 'package:escooter_notes_app/screens/common/e_splash_screen.dart';
import 'package:escooter_notes_app/screens/notes/note_details.dart';
import 'package:escooter_notes_app/screens/notes/notes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'named_navigator.dart';

final goRouter = GoRouter(
  navigatorKey: NamedNavigatorImpl.navigatorState,
  initialLocation: Routes.SPLASH_SCREEN,
  routes: [
    GoRoute(
      path: Routes.SPLASH_SCREEN,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ESplashScreen(),
      ),
    ),
    GoRoute(
      path: Routes.LOGIN_SCREEN,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const Login(),
      ),
    ),
    GoRoute(
      path: Routes.SIGN_UP_SCREEN,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const SignUp(),
      ),
    ),
    GoRoute(
      path: Routes.VERIFICATION_SCREEN,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const VerificationScreen(),
      ),
    ),
    GoRoute(
      path: Routes.NOTES_SCREEN,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const Notes(),
      ),
    ),
    GoRoute(
      path: Routes.NOTE_DETAILS,
      pageBuilder: (context, state) {
        final noteId = state.pathParameters['noteId'];
        return MaterialPage(
          key: state.pageKey,
          child: NoteDetails(noteId: noteId),
        );
      },
    ),
  ],
);

abstract class NamedNavigator {
  void pop({dynamic result});

  Future<dynamic> push(String routeName,
      {dynamic arguments, bool clean = false});
}

class NamedNavigatorImpl implements NamedNavigator {
  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();

  @override
  void pop({dynamic result}) {
    final context = navigatorState.currentContext;
    if (context != null) {
      context.pop(result);
    }
  }

  @override
  Future<dynamic> push(String routeName,
      {dynamic arguments, bool clean = false}) {
    final context = navigatorState.currentContext;
    if (context == null) return Future.value(null);

    if (clean) {
      // Use GoRouter's go() for clean navigation
      context.go(routeName, extra: arguments);
      return Future.value(null); // go() returns void
    }

    // Use push() for normal navigation
    return context.push(routeName, extra: arguments);
  }
}
