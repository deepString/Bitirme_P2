import 'package:go_router/go_router.dart';

import '../screens/authLoading.dart';
import '../screens/boardingScreen.dart';
import '../screens/changePassword.dart';
import '../screens/errorScreen.dart';
import '../screens/favoritesMusics.dart';
import '../screens/homeScreen.dart';
import '../screens/libraryScreen.dart';
import '../screens/loginScreen.dart';
import '../screens/musicRecognize.dart';
import '../screens/profileScreen.dart';
import '../screens/registerScreen.dart';
import '../screens/resetPassword.dart';
import '../screens/searchScreen.dart';
import '../screens/settingScreen.dart';
import '../screens/welcomeScreen.dart';

// GoRouter configuration
final routes = GoRouter(
  errorBuilder: (context, state) => const ErrorScreen(),
  routes: [
    GoRoute(
      path: '/',
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
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/library',
      builder: (context, state) => const LibraryScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
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
  ],
);