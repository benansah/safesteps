import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_log.dart';
import '../core/constants.dart';
import '../providers/user_provider.dart';

class RecordDetailScreen extends StatelessWidget {
  const RecordDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final log = ModalRoute.of(context)?.settings.arguments as GameLog?;
    if (log == null) {
      return Scaffold(
        appBar: AppBar(title: Text(userProvider.translate('recordDetail'))),
        body: Center(child: Text(userProvider.translate('noRecordAvailable'))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(userProvider.translate('recordDetail'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(log.scenarioTitle,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('${userProvider.translate('studentIdLabel')}: ${log.userId}'),
            const SizedBox(height: 4),
            Text('${userProvider.translate('score')}: ${log.totalScore.toStringAsFixed(0)}'),
            const SizedBox(height: 4),
            Text('${userProvider.translate('riskLevel')}: ${log.riskLevel}'),
            const SizedBox(height: 4),
            Text('${userProvider.translate('sessionDate')}: ${log.createdAt.toLocal()}'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: log.decisions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final decision = log.decisions[index];
                  return ListTile(
                    title: Text('${userProvider.translate('choiceLabel')} ${decision.choiceId}'),
                    subtitle: Text('${userProvider.translate('riskValue')} ${decision.riskValue}'),
                    trailing: Text('${decision.decisionTime.inSeconds}s'),
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
