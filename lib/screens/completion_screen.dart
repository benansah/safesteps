import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/help_button.dart';
import '../core/routes.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({super.key});

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<GameProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    provider.completeSession().then((_) {
      userProvider.incrementSessionCount(provider.riskScore?.isHighRisk ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final score = gameProvider.riskScore;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: Lottie.network(
                        'https://assets9.lottiefiles.com/packages/lf20_jbrw3hcz.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Well done!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userProvider.translate('keepLearning'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Summary', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 12),
                          Text('Choices: ${gameProvider.decisions.length}'),
                          const SizedBox(height: 8),
                          Text('Risk score: ${score?.totalScore.toStringAsFixed(1) ?? 0}'),
                          const SizedBox(height: 8),
                          Text('Risk level: ${score?.level.name ?? 'low'}'),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
                      },
                      child: Text(userProvider.translate('playNext')),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(top: 40, right: 20, child: const HelpButton()),
        ],
      ),
    );
  }
}
