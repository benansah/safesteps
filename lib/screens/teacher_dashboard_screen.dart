import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/routes.dart';
import '../providers/user_provider.dart';
import '../services/storage_service.dart';
import '../models/game_log.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRisk = 'All';
  String _selectedSort = 'Latest';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
        title: Text(userProvider.translate('teacherDashboard')),
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
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: userProvider.translate('searchStudents'),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.teacherAnalytics);
                  },
                  icon: const Icon(Icons.bar_chart),
                  label: Text(userProvider.translate('analytics')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedRisk,
                    decoration: InputDecoration(
                      labelText: userProvider.translate('riskFilter'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: ['All', 'Low', 'Medium', 'High']
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(userProvider.translate(value.toLowerCase())),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRisk = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSort,
                    decoration: InputDecoration(
                      labelText: userProvider.translate('sortBy'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: ['Latest', 'Oldest', 'Name']
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(userProvider.translate(value.toLowerCase())),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSort = value;
                        });
                      }
                    },
                  ),
                ),                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _exportData(),
                  icon: const Icon(Icons.download),
                  label: const Icon(Icons.download_outlined),
                ),              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<GameLog>>(
                future: StorageService.instance.fetchAllLogs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(userProvider.translate('dataLoadError')));
                  }
                  final logs = snapshot.data ?? [];
                  final filteredGroups = _filterGroups(logs);
                  if (filteredGroups.isEmpty) {
                    return Center(
                        child: Text(userProvider.translate('noStudentFiles')));
                  }
                  return ListView.builder(
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      final group = filteredGroups[index];
                      final studentId = group.key;
                      final studentLogs = group.value;
                      final displayName = studentLogs.first.userName.isNotEmpty
                          ? studentLogs.first.userName
                          : studentId;
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                        child: ExpansionTile(
                          title: Text(displayName),
                          subtitle: Text(
                              '${userProvider.translate('studentIdLabel')}: $studentId • ${studentLogs.length} ${userProvider.translate('sessions')}'),
                          children: studentLogs.map((log) {
                            return ListTile(
                              title: Text(log.scenarioTitle),
                              subtitle: Text(
                                  '${userProvider.translate('riskLevel')}: ${log.riskLevel}'),
                              trailing: Text(log.totalScore.toStringAsFixed(0)),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.recordDetail,
                                  arguments: log,
                                );
                              },
                            );
                          }).toList(),
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

  Future<void> _exportData() async {
    final logs = await StorageService.instance.fetchAllLogs();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    final filteredGroups = _filterGroups(logs);
    
    final StringBuffer csv = StringBuffer();
    csv.writeln('Student Name,Student ID,Scenario,Score,Risk Level,Date');
    
    for (final group in filteredGroups) {
      for (final log in group.value) {
        final displayName = log.userName.isNotEmpty ? log.userName : log.userId;
        csv.writeln('${displayName},${log.userId},${log.scenarioTitle},${log.totalScore.toStringAsFixed(0)},${log.riskLevel},${log.createdAt}');
      }
    }
    
    await Share.share(
      csv.toString(),
      subject: 'Student Records Report - ${DateTime.now().toString().split(' ')[0]}',
    );
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(userProvider.translate('exportedSuccessfully')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<MapEntry<String, List<GameLog>>> _filterGroups(List<GameLog> logs) {
    final searchTerm = _searchController.text.trim().toLowerCase();
    final riskFilter = _selectedRisk.toLowerCase();

    final grouped = <String, List<GameLog>>{};
    for (final log in logs) {
      final matchesSearch = searchTerm.isEmpty ||
          log.userId.toLowerCase().contains(searchTerm) ||
          log.userName.toLowerCase().contains(searchTerm);
      final matchesRisk = riskFilter == 'all' ||
          log.riskLevel.toLowerCase() == riskFilter;
      if (matchesSearch && matchesRisk) {
        grouped.putIfAbsent(log.userId, () => []).add(log);
      }
    }

    final entries = grouped.entries.toList();
    for (final entry in entries) {
      entry.value.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    if (_selectedSort == 'Oldest') {
      entries.sort((a, b) => a.value.last.createdAt.compareTo(b.value.last.createdAt));
    } else if (_selectedSort == 'Latest') {
      entries.sort((a, b) => b.value.first.createdAt.compareTo(a.value.first.createdAt));
    } else if (_selectedSort == 'Name') {
      entries.sort((a, b) {
        final aName = a.value.first.userName.toLowerCase();
        final bName = b.value.first.userName.toLowerCase();
        return aName.compareTo(bName);
      });
    }

    return entries;
  }
}
