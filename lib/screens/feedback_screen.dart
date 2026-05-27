import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes.dart';
import '../models/scenario.dart';
import '../providers/user_provider.dart';
import '../widgets/help_button.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final choiceData = args?['choice'] as Map<String, dynamic>?;
    final choice = choiceData != null ? Choice(
      id: choiceData['id'] as String? ?? '',
      text: choiceData['text'] as String? ?? '',
      textTwi: choiceData['textTwi'] as String? ?? '',
      riskValue: choiceData['riskValue'] as int? ?? 0,
      nextNodeId: choiceData['nextNodeId'] as String? ?? '',
      feedbackText: choiceData['feedbackText'] as String? ?? '',
      feedbackTextTwi: choiceData['feedbackTextTwi'] as String? ?? '',
    ) : null;
    final isEnding = args?['isEnding'] as bool? ?? false;
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);

    if (choice == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Feedback')),
        body: const Center(child: Text('No feedback available.')),
      );
    }

    final safe = choice.riskValue == 0;
    final backgroundColor = safe ? const Color(0xFFE8F6EF) : const Color(0xFFFFF3E0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    safe ? userProvider.translate('safeChoice') : userProvider.translate('riskyChoice'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: safe ? const Color(0xFF1E8449) : const Color(0xFFB7770D),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    choice.feedbackText,
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  if (!safe)
                    ExpansionTile(
                      title: Text(userProvider.translate('whatShouldIDo')),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(choice.feedbackText, style: theme.textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isEnding) {
                          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(userProvider.translate('continue')),
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
