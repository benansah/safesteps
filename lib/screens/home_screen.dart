import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants.dart';
import '../core/routes.dart';
import '../providers/game_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/help_button.dart';
import '../widgets/risk_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    final pages = [
      _buildHomePage(context, userProvider, gameProvider),
      _buildProgressPage(context, userProvider),
      _buildSettingsPage(context, userProvider),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Stack(
        children: [
          pages[selectedIndex],
          Positioned(
            top: 40,
            right: 20,
            child: HelpButton(highRisk: false),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: userProvider.translate('progress')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.show_chart),
              label: userProvider.translate('progress')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: userProvider.translate('settings')),
        ],
      ),
    );
  }

  Widget _buildHomePage(BuildContext context, UserProvider userProvider,
      GameProvider gameProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userProvider.translate('appName'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              userProvider.displayName.isNotEmpty
                  ? '${userProvider.translate('greeting')} ${userProvider.displayName}'
                  : userProvider.translate('greeting'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (userProvider.isStudent)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.profile);
                },
                icon: const Icon(Icons.person_outline),
                label: Text(userProvider.translate('viewProfile')),
              ),
            if (userProvider.isStudent) const SizedBox(height: 20),
            if (!userProvider.isStudent) const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: allScenarios.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 3.5,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final scenario = allScenarios[index];
                  final unlocked =
                      index == 0 || userProvider.sessionCount >= index;
                  return InkWell(
                    onTap: unlocked && scenario.nodes.isNotEmpty
                        ? () {
                            gameProvider.startSession(scenario);
                            Navigator.of(context).pushNamed(AppRoutes.game);
                          }
                        : null,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(scenario.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  const SizedBox(height: 6),
                                  Text(scenario.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      const Icon(Icons.lock, size: 16),
                                      const SizedBox(width: 6),
                                      Text(unlocked ? 'Unlocked' : 'Locked'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            RiskBadge(
                                level: _difficultyToLabel(scenario.weight)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressPage(BuildContext context, UserProvider userProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userProvider.translate('progress'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${userProvider.translate('sessions')}: ${userProvider.sessionCount}',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 12),
                    Text(
                        '${userProvider.translate('highRiskFlags')}: ${userProvider.highRiskCount}',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 12),
                    Text(
                        'Average risk trend: ${userProvider.sessionCount > 0 ? (userProvider.highRiskCount / userProvider.sessionCount * 100).round() : 0}%',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPage(BuildContext context, UserProvider userProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(userProvider.translate('settings'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: userProvider.translate('teacherMode'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final pin = int.tryParse(_pinController.text.trim());
                if (pin != null && userProvider.validateTeacherPin(pin)) {
                  _shareReport(userProvider);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid PIN.')));
                }
              },
              child: Text(userProvider.translate('exportData')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareReport(UserProvider userProvider) async {
    final report = '''${userProvider.translate('sessionReport')}
------------------------
${userProvider.translate('sessions')}: ${userProvider.sessionCount}
${userProvider.translate('highRiskFlags')}: ${userProvider.highRiskCount}
${userProvider.translate('helpActivations')}: ${userProvider.helpActivations}
${userProvider.translate('mostCommonRiskyScenario')}: The Job Offer
${userProvider.translate('exportDate')}: ${DateTime.now().toLocal()}
''';
    await SharePlus.instance.share(ShareParams(
      text: report,
      title: userProvider.translate('sessionReport'),
    ));
  }

  String _difficultyToLabel(int weight) {
    switch (weight) {
      case 3:
        return 'High';
      case 2:
        return 'Medium';
      default:
        return 'Low';
    }
  }
}
