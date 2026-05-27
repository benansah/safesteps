import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/routes.dart';
import '../providers/user_provider.dart';
import '../services/storage_service.dart';
import '../models/game_log.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  late String _selectedStudentId;

  @override
  void initState() {
    super.initState();
    _selectedStudentId = Provider.of<UserProvider>(context, listen: false).studentId;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isParent) {
      Future.microtask(() {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(userProvider.translate('parentDashboard')),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userProvider.translate('selectStudent'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: userProvider.translate('studentId'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedStudentId = value.trim();
                });
              },
            ),
            const SizedBox(height: 20),
            if (_selectedStudentId.isEmpty)
              Center(
                child: Text(userProvider.translate('selectAStudent')),
              )
            else
              Expanded(
                child: FutureBuilder<List<GameLog>>(
                  future: StorageService.instance.fetchLogsForUser(_selectedStudentId),
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
                    logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                    final highRiskCount = logs.where((l) => l.riskLevel.toLowerCase() == 'high').length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (highRiskCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.red.shade700),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${userProvider.translate('highRiskAlert')}: $highRiskCount ${userProvider.translate('highRiskSessions')}',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: logs.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final log = logs[index];
                              final isHighRisk = log.riskLevel.toLowerCase() == 'high';
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: isHighRisk ? Colors.red.shade50 : null,
                                elevation: 3,
                                child: ListTile(
                                  title: Text(log.scenarioTitle),
                                  subtitle: Text(
                                    '${userProvider.translate('riskLevel')}: ${log.riskLevel}',
                                    style: TextStyle(
                                      color: isHighRisk ? Colors.red : null,
                                      fontWeight: isHighRisk ? FontWeight.bold : null,
                                    ),
                                  ),
                                  trailing: Text(log.totalScore.toStringAsFixed(0)),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      AppRoutes.recordDetail,
                                      arguments: log,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

