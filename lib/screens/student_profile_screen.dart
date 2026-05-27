import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../providers/user_provider.dart';
import '../services/storage_service.dart';
import '../models/game_log.dart';
import '../core/routes.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.userId;
    return Scaffold(
      appBar: AppBar(
        title: Text(userProvider.translate('studentProfile')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 48),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userProvider.displayName,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 4),
                              Text(
                                  '${userProvider.translate('studentIdLabel')}: ${userProvider.studentId}',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 4),
                              Text(
                                  '${userProvider.translate('sessions')}: ${userProvider.sessionCount}',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(userProvider.translate('recentRecords'),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<GameLog>>(
                future: StorageService.instance.fetchLogsForUser(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(userProvider.translate('dataLoadError')));
                  }
                  final logs = snapshot.data ?? [];
                  if (logs.isEmpty) {
                    return Center(
                        child: Text(userProvider.translate('noStudentFiles')));
                  }
                  logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  return ListView.separated(
                    itemCount: logs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                        child: ListTile(
                          title: Text(log.scenarioTitle),
                          subtitle: Text(
                              '${userProvider.translate('riskLevel')}: ${log.riskLevel}'),
                          trailing:
                              Text(log.totalScore.toStringAsFixed(0)),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.recordDetail,
                              arguments: log,
                            );
                          },
                        ),
                      );
                    },
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
