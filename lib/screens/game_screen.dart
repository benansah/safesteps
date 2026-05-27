import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes.dart';
import '../providers/game_provider.dart';
import '../providers/user_provider.dart';
import '../services/audio_service.dart';
import '../widgets/choice_card.dart';
import '../widgets/help_button.dart';
import '../widgets/progress_bar.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioService _audioService = AudioService();
  bool loadedAudio = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final scenario = gameProvider.currentScenario;
    if (scenario != null && !loadedAudio) {
      _audioService.loadScenarioAudio(scenario.id, userProvider.localeCode).then((_) {
        if (mounted) setState(() => loadedAudio = true);
      });
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final gameProvider = Provider.of<GameProvider>(context);
    final scenario = gameProvider.currentScenario;
    final node = gameProvider.currentNode;

    if (scenario == null || node == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Game')),
        body: const Center(child: Text('No active scenario.')),
      );
    }

    final displayText = userProvider.localeCode == 'tw' ? node.textTwi : node.text;
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          scenario.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ProgressBar(current: gameProvider.nodeIndex, total: gameProvider.totalNodes),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        displayText,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_audioService.hasSource)
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_audioService.isPlaying) {
                              await _audioService.pause();
                            } else {
                              await _audioService.play();
                            }
                            setState(() {});
                          },
                          icon: Icon(_audioService.isPlaying ? Icons.pause : Icons.play_arrow),
                          label: Text(_audioService.isPlaying ? 'Pause audio' : 'Play audio'),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  ...node.choices.map(
                    (choice) => ChoiceCard(
                      choice: choice,
                      onSelect: () async {
                        await gameProvider.makeChoice(choice);
                        Navigator.of(context).pushNamed(AppRoutes.feedback, arguments: {
                          'choice': choice.toJson(),
                          'isEnding': choice.nextNodeId.isEmpty,
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(top: 40, right: 20, child: HelpButton(highRisk: gameProvider.riskScore?.isHighRisk ?? false)),
        ],
      ),
    );
  }
}
