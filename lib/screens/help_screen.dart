import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../core/constants.dart';
import '../providers/game_provider.dart';
import '../providers/user_provider.dart';
import '../services/storage_service.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  Future<void> _launchHelp(BuildContext context) async {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final sessionId = provider.riskScore?.sessionId ?? provider.currentScenario?.id ?? 'unknown';
    final message = Uri.encodeComponent('Hello, I need help. I feel unsafe. Please contact me.');
    final url = 'https://wa.me/${hotlineNumber.replaceAll('+', '')}?text=$message';
    await StorageService.instance.logHelpActivation(sessionId: sessionId);
    await userProvider.incrementHelpCount();
    await StorageService.instance.syncGameLogs();
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A5276),
      appBar: AppBar(backgroundColor: const Color(0xFF1A5276), title: const Text('Help')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userProvider.translate('helpTitle'), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 24),
              Text(userProvider.translate('helpConfirm'), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => _launchHelp(context),
                child: Text(userProvider.translate('yes')),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(userProvider.translate('no'), style: const TextStyle(color: Colors.black87)),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userProvider.translate('trustedAdult'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    const Text('Write a trusted contact name here:'),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Parent, teacher, or counselor',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
