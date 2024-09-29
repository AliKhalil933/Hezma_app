import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:hezmaa/helper/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      GoRouter.of(context).go(AppRoutes.onBoardingPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(backgroundcolor1),
        child: Center(
          child: Image.asset('assets/logos/Logo Hezma.png'),
        ),
      ),
    );
  }
}
