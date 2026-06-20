import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final setupDone = prefs.getBool('setup_complete') ?? false;
  runApp(SafeStepsApp(showOnboarding: !setupDone));
}

class SafeStepsApp extends StatelessWidget {
  final bool showOnboarding;
  const SafeStepsApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeSteps',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: showOnboarding ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}
