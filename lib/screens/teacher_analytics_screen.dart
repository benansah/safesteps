import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes.dart';
import '../providers/user_provider.dart';
import '../services/storage_service.dart';
import '../models/game_log.dart';

class TeacherAnalyticsScreen extends StatelessWidget {
  const TeacherAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isTeacher) {
      Future.microtask(() {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(userProvider.translate('analytics')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await userProvider.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<GameLog>>(
          future: StorageService.instance.fetchAllLogs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(userProvider.translate('dataLoadError')),
              );
            }
            final logs = snapshot.data ?? [];
            if (logs.isEmpty) {
              return Center(
                child: Text(userProvider.translate('noStudentFiles')),
              );
            }

            final totalSessions = logs.length;
            final highRiskSessions = logs.where((l) => l.riskLevel.toLowerCase() == 'high').length;
            final mediumRiskSessions = logs.where((l) => l.riskLevel.toLowerCase() == 'medium').length;
            final lowRiskSessions = logs.where((l) => l.riskLevel.toLowerCase() == 'low').length;
            final avgRisk = logs.isEmpty ? 0.0 : logs.map((l) => l.totalScore).reduce((a, b) => a + b) / logs.length;
            
            final scenarioCount = <String, int>{};
            for (final log in logs) {
              scenarioCount[log.scenarioTitle] = (scenarioCount[log.scenarioTitle] ?? 0) + 1;
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProvider.translate('analytics'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildStatCard(
                        context,
                        userProvider.translate('totalSessions'),
                        totalSessions.toString(),
                        Colors.blue,
                      ),
                      _buildStatCard(
                        context,
                        userProvider.translate('averageRisk'),
                        avgRisk.toStringAsFixed(1),
                        Colors.orange,
                      ),
                      _buildStatCard(
                        context,
                        userProvider.translate('highRiskSessions'),
                        highRiskSessions.toString(),
                        Colors.red,
                      ),
                      _buildStatCard(
                        context,
                        '${userProvider.translate('high')}: $highRiskSessions / ${userProvider.translate('medium')}: $mediumRiskSessions',
                        '${userProvider.translate('low')}: $lowRiskSessions',
                        Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    userProvider.translate('trends'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...scenarioCount.entries.toList().asMap().entries.map((e) {
                    final scenario = e.value.key;
                    final count = e.value.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(scenario),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('$count ${userProvider.translate('sessions')}'),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
