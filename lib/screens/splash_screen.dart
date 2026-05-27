import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shield, size: 96, color: Color(0xFF1A5276)),
            const SizedBox(height: 24),
            Text(
              AppStrings.en['appName']!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF1A5276),
                    fontSize: 36,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.en['tagline']!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF2874A6),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
