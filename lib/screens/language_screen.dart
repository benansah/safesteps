import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/routes.dart';
import '../providers/user_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('SafeSteps')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose your language',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _languageCard(
                    context,
                    label: AppStrings.en['english']!,
                    subtitle: 'English interface',
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      await userProvider.setLanguage('en');
                      if (!context.mounted) return;
                      navigator.pushReplacementNamed(AppRoutes.login);
                    },
                  ),
                  const SizedBox(height: 20),
                  _languageCard(
                    context,
                    label: AppStrings.en['twi']!,
                    subtitle: 'Twi (Akan) interface',
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      await userProvider.setLanguage('tw');
                      if (!context.mounted) return;
                      navigator.pushReplacementNamed(AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageCard(BuildContext context,
      {required String label,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
