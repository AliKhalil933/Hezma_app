import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hezmaa/Emails/login.dart';
import 'package:hezmaa/Emails/siginup.dart';

import 'package:hezmaa/Views/onBoarding_screan/onBoarding_screan.dart';
import 'package:hezmaa/Views/screens/purchases_page.dart';
import 'package:hezmaa/Views/splash_screan/splash_view.dart';

abstract class AppRoutes {
  static const siginpath = '/IntroPage6';
  static const splashPath = '/splash';
  static const onBoardingPath = '/onboarding';

  static const log = '/loginPage';

  static final GoRouter router = GoRouter(
    initialLocation: splashPath, // تعيين الصفحة الأولى التي سيتم عرضها
    routes: [
      GoRoute(
        path: splashPath,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: onBoardingPath,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: siginpath,
        builder: (context, state) => const SiginUpPage(),
      ),
      GoRoute(
        path: log,
        builder: (context, state) => const LoginPage(),
      )
    ],
  );
}
