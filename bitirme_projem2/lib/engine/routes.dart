import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/authLoading.dart';
import '../screens/boardingScreen.dart';
import '../screens/changePassword.dart';
import '../screens/errorScreen.dart';
import '../screens/favoritesMusics.dart';
import '../screens/homeOffScreen.dart';
import '../screens/homeScreen.dart';
import '../screens/libraryScreen.dart';
import '../screens/loginScreen.dart';
import '../screens/musicRecognize.dart';
import '../screens/permissionScreen.dart';
import '../screens/profileScreen.dart';
import '../screens/registerScreen.dart';
import '../screens/resetPassword.dart';
import '../screens/searchScreen.dart';
import '../screens/settingScreen.dart';
import '../screens/splashScreen.dart';
import '../screens/welcomeScreen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final routes = GoRouter(
  errorBuilder: (context, state) => const ErrorScreen(),
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => HomeOffScreen(
        state: state,
        child: child,
      ),
      routes: [
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: '/home',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: '/search',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SearchScreen()),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: '/library',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LibraryScreen()),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: '/profile',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/authLoad',
      builder: (context, state) => const AuthLoadingScreen(),
    ),
    GoRoute(
      path: '/boarding',
      builder: (context, state) => const BoardingScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/resetPass',
      builder: (context, state) => const ResetPassword(),
    ),
    GoRoute(
      path: '/changePass',
      builder: (context, state) => const ChangePassword(),
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state) => const SettingScreen(),
    ),
    GoRoute(
      path: '/musicRecognize',
      builder: (context, state) => const MusicRecognizeScreen(),
    ),
    GoRoute(
      path: '/favorite',
      builder: (context, state) => const FavoritesMusicsScreen(),
    ),
    GoRoute(
      path: '/perms',
      builder: (context, state) => const PermissionScreen(),
    ),
  ],
);